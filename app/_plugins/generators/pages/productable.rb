# frozen_string_literal: true

module Jekyll
  module Pages
    module Productable
      def parts
        @parts ||= Pathname(path).each_filename.to_a
      end

      def path
        # Remove the generated prefix if it's present
        @path ||= if @page.is_a?(Jekyll::GeneratorSingleSource::SingleSourcePage) || @page.data['is_latest']
                    @page.dir.delete_prefix('/')
                  else
                    @page.path
                  end
      end

      def product
        @product ||= parts[0]
      end

      def products
        @products ||= @page.site.data['editions'].keys
      end
    end
  end
end
