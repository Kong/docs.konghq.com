module Jekyll
  class Books < Jekyll::Generator
    def generate(site)
      books = Hash.new

      site.pages.each do |page|
        if page.data.key?("book")
          (books["#{Pathname(page.path).dirname}/#{page.data["book"]}"] ||= []).push(page)
        end
      end

      books.each do |name, pages|
        # Sort pages by page number
        pages.sort! {|a,b| a.data["chapter"] <=> b.data["chapter"]}

        # Insert next and previous link
        pages.each_with_index do |page, idx|
          page.data["book"] = {
            "chapters" => {}
          }

          if idx > 0
            page.data["book"]["previous"] = pages[idx - 1].url
          end

          if idx < pages.size - 1
            page.data["book"]["next"] = pages[idx + 1].url
          end

          # Add all existing pages links to this page
          pages.each do |p|
            p_basename = p.basename
            if p_basename != page.basename
              page.data["book"]["chapters"][p_basename] = p.url
            end
          end
        end
      end
    end
  end
end
