module Jekyll
    class RenderMermaid < Liquid::Block
  
      def render(context)
        text = super

        "<script type='module'>"\
        "import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@10/dist/mermaid.esm.min.mjs';"\
        "mermaid.initialize({ startOnLoad: true });"\
        "</script>"\
        "<pre class='mermaid'> #{text}  </pre>"
    
      end
  
    end
  end
  
  Liquid::Template.register_tag('mermaid', Jekyll::RenderMermaid)