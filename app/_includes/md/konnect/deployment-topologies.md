<!--vale off -->
{% mermaid %}
flowchart TD
A(Dev Portal &bull; Gateway Manager &bull; Analytics &bull; {{site.service_catalog_name}})
B(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> Kong-managed control plane \n #40;{{site.base_gateway}} instance#41;)
C(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 1\n #40;{{site.base_gateway}} instance#41;)
D(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 2\n #40;{{site.base_gateway}} instance#41;)

subgraph id1 [Konnect]
A --- B
end

B --Kong proxy 
configuration---> id2

subgraph id2 [Fully-managed cloud nodes]
C
D
end

style id1 stroke-dasharray:3,rx:10,ry:10
style id2 stroke-dasharray:3,rx:10,ry:10
style B stroke:none,fill:#0E44A2,color:#fff
{% endmermaid %}
<!-- vale on-->