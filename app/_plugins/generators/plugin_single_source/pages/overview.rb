# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Overview < Base
      def canonical_url
        base_url
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/"
        end
      end

      def page_title
        "#{@release.metadata['name']} Overview"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/"
      end

      private

      def ssg_hub
        @release.latest?
      end

      def page_attributes
        super.merge('layout' => 'extension')
      end
    end
  end
end
