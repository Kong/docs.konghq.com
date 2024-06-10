# frozen_string_literal: true

module OasDefinition
  class ErrorPage < ::Jekyll::Page
    def initialize(site:, data:) # rubocop:disable Lint/MissingSuper
      # Prevent modification of source data that's used in OasDefinition::Page
      data = data.clone

      @site = site
      @base = site.source

      @basename = 'index'
      @ext = '.html'

      @data = data
      @relative_path = data['source_file']

      # Error specific overrides
      override_data_for_error!
      api_path = api_spec_path

      unless api_path
        @content = 'This API does not have error definitions.'
        return
      end

      spec = load_api_file(api_path)
      @content = generate_error_table(spec)
    end

    private

    def override_data_for_error!
      @dir = "#{data['dir']}errors/"
      @data['layout'] = 'docs-v2'
      @data['permalink'] = "#{@data['permalink']}errors/"
      @data['no_version'] = true
    end

    def generate_error_table(spec) # rubocop:disable Metrics/MethodLength
      return '' unless spec['x-errors']

      # heredoc string return
      <<~HEREDOC
        <div><a class="no-link-icon" href="../">&laquo; Back to API</a></div>
        <table class="table table-striped">
          <thead>
            <tr>
              <th>Code</th>
              <th>Description</th>
              <th>Resolution</th>
              <th></th>
            </tr>
          </thead>
          <tbody>
            #{spec['x-errors'].map { |k, v| generate_error_row(k, v) }.join("\n")}
          </tbody>
        </table>
      HEREDOC
    end

    def generate_error_row(key, error)
      # heredoc string return
      <<~HEREDOC
        <tr id="#{key}">
          <td>#{key}</td>
          <td>#{error['description']}</td>
          <td>#{error['resolution']}</td>
          <td>#{generate_error_link(error['link'])}</td>
        </tr>
      HEREDOC
    end

    def generate_error_link(link)
      return '' unless link

      "<a href=\"#{link['url']}\">#{link['text']}</a>"
    end

    def api_spec_path
      return nil unless @data['insomnia_link']
 
      spec_file = CGI.unescape(@data['insomnia_link']).split('&uri=')[1].gsub(
        'https://raw.githubusercontent.com/Kong/docs.konghq.com/main/', ''
      )
      File.join(@base, '..', spec_file)
    end

    def load_api_file(api_path)
      YAML.load_file(api_path)
    end
  end
end
