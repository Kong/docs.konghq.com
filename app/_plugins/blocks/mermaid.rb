# frozen_string_literal: true

module Jekyll
  class RenderMermaid < Liquid::Block
    def render(context)
      text = super
      mermaid_script = generate_mermaid_script
      mermaid_pre = "<pre class='mermaid'> #{text}  </pre>"

      "#{mermaid_script}#{mermaid_pre}"
    end

    private

    def generate_mermaid_script
      <<~SCRIPT
        <script type='module'>
          import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';
          mermaid.initialize({
            startOnLoad: true,
            theme: 'base',
            themeVariables: {
              'primaryColor': '#fff',
              'primaryBorderColor': '#4a86e8',
              'primaryTextColor': '#495c64',
              'secondaryColor': '#fff',
              'secondaryTextColor': '#5096f2',
              'edgeLabelBackground': '#fff',
              'fontFamily': 'Roboto',
              'fontSize': '15px',
              'lineColor': '#99b0c0'
            }
          });
        </script>
      SCRIPT
    end
  end
end

Liquid::Template.register_tag('mermaid', Jekyll::RenderMermaid)
