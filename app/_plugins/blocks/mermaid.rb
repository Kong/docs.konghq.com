module Jekyll
    class RenderMermaid < Liquid::Block
  
      def render(context)
        text = super

        "<script type='module'>"\
        "import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';"\
        "mermaid.initialize({ 
          startOnLoad: true,
          theme: 'base',
          themeVariables: {
            'primaryColor': '#fff',
            'primaryBorderColor': '#4a86e8',
            'primaryTextColor': '#495c64',
            'secondaryColor': '#fff',
            'secondaryTextColor': '#5096f2',
            'edgeLabelBackground': '#fff',
            'clusterBkg': '#dcf2ffff',
            'fontFamily': 'Roboto',
            'fontSize': '15px',
            'lineColor': '#99b0c0'
            }
          });"\
        "</script>"\
        "<pre class='mermaid'> #{text}  </pre>"
    
      end
  
    end
  end
  
  Liquid::Template.register_tag('mermaid', Jekyll::RenderMermaid)