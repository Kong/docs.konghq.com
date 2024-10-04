# frozen_string_literal: true

module Jekyll
  module GeneratorSingleSource
    module Liquid
      module Tags
        class VersionIs < ::Liquid::Block
          attr_reader :blocks

          def initialize(tag_name, markup, options)
            super
            @blocks = []
            push_block('if_version'.freeze, markup)
          end

          def nodelist
            @blocks.map(&:attachment)
          end

          def parse(tokens)
            while parse_body(@blocks.last.attachment, tokens)
            end
          end

          def unknown_tag(tag, markup, tokens)
            if 'else'.freeze == tag
              push_block(tag, markup)
            else
              super
            end
          end

          def render(context)
            context.stack do
              @blocks.each do |block|
                if block.evaluate(context)
                  return block.attachment.render(context)
                end
              end
              ''.freeze
            end
          end

          private

          def push_block(tag, markup)
            block = if tag == 'else'.freeze
                      ::Liquid::ElseCondition.new
                    else
                      parse_with_selected_parser(markup)
                    end

            @blocks.push(block)
            block.attach(::Liquid::BlockBody.new)
          end

          def lax_parse(markup)
            parse_condition(markup)
          end

          def strict_parse(markup)
            parse_condition(markup)
          end

          def parse_condition(markup)
            IfVersionCondition.new(markup)
          end

          class IfVersionCondition < ::Liquid::Condition
            # Extracted from:
            # https://github.com/Shopify/liquid/blob/ae3057e94b7c4d657e6bc02e1d50398e34cc6ed7/lib/liquid.rb#L37
            # and modified to support comma-separated values
            TAG_ATTRIBUTES = /(\w+)\s*\:\s*((?-mix:(?-mix:"[^"]*"|'[^']*')|(?:[^\s\|'"]|(?-mix:"[^"]*"|'[^']*'))+))/o

            def else?
              false
            end

            def evaluate(context)
              params = {}
              @left.scan(TAG_ATTRIBUTES) do |key, value|
                params[key.to_sym] = value
              end

              page = context.environments.first['page']

              current_version = to_version(context.environments.first['page']['kong_version'])

              if params.key? :eq
                # If there's an exact match, check only that
                versions = params[:eq].split(',').map { |v| to_version(v) }
                return false unless versions.any? { |v| v == current_version }
              end
              if params.key? :gte
                # If there's a greater than or equal to check, fail if it's lower
                version = to_version(params[:gte])
                return false unless current_version >= version
              end
              if params.key? :lte
                # If there's a less than or equal to check, fail if it's higher
                version = to_version(params[:lte])
                return false unless current_version <= version
              end
              if params.key? :neq
                # If there's a not-equal to check, fail if they are equal
                version = to_version(params[:neq])
                return false if current_version == version
              end

              true
            end

            def to_version(input)
              Gem::Version.new(input.to_s.gsub(/\.x$/, '.0'))
            end
          end

          class ParseTreeVisitor < ::Liquid::ParseTreeVisitor
            def children
              @node.blocks
            end
          end
        end

      end
    end
  end
end

::Liquid::Template.register_tag('if_version'.freeze, Jekyll::GeneratorSingleSource::Liquid::Tags::VersionIs)
