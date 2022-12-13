# frozen_string_literal: true

module Jekyll
  class Alias < Jekyll::Generator
    priority :lowest

    def generate(site)
      static_files = [
        "app/_headers"
      ]

      static_files.each do |path|
        content = File.read(path)

        page = PageWithoutAFile.new(site, __dir__, '', path.sub('app/',''))
        page.content = content
        page.data['layout'] = nil
        site.pages << page
      end
    end
  end
end
