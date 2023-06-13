# frozen_string_literal: true

module PluginSingleSource
    module Pages
      class References < Base
        def canonical_url
          "#{base_url}api/"
        end
  
        def permalink
          if @release.latest?
            canonical_url
          else
            "#{base_url}#{@release.version}/api/"
          end
        end
  
        def page_title
          "#{@release.metadata['name']} API reference"
        end
  
        def dropdown_url
          @dropdown_url ||= "#{base_url}VERSION/api/"
        end
  
        def nav_title
          'API Reference'
        end
  
        def icon
          '/assets/images/icons/documentation/hub/icn-reference.svg'
        end
  
        def breadcrumb_title
          page_title
        end
  
        private
  
        def ssg_hub
          false
        end
      end
    end
  end
  