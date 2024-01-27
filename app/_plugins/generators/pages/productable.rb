# frozen_string_literal: true

module Jekyll
  module Pages
    module Productable
      def parts
        @parts ||= Pathname(path).each_filename.to_a
      end

      def path
        # Remove the generated prefix if it's present
        @path ||= if @page.relative_path.start_with?('_src')
                    @page.dir.delete_prefix('/')
                  else
                    @page.path
                  end
      end

      def product
        @product ||= parts[0]
      end

      def products
        @products ||= Jekyll::GeneratorSingleSource::Product::Edition
                      .all(site: @site)
                      .keys
      end
    end
  end
end
