{% if include.topology == "konnect" %}
<!--vale off -->
{% mermaid %}
flowchart TD
A(Dev Portal &bull; Gateway Manager &bull; Analytics &bull; {{site.service_catalog_name}})
B(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> Control plane \n #40;{{site.base_gateway}} instance#41;)
B2(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> Control plane \n #40;{{site.base_gateway}} instance#41;)
C(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 3\n #40;{{site.base_gateway}} instance#41;)
D(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 1\n #40;{{site.base_gateway}} instance#41;)
E(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 2\n #40;{{site.base_gateway}} instance#41;)

subgraph id1 [Konnect]
A --- B & B2
end

id1 --Kong proxy 
configuration---> id2 & id3

subgraph id2 [Kong-managed cloud node]
C
end

subgraph id3 [Self-managed local and cloud nodes]
D
E
end

style id1 stroke-dasharray:3,rx:10,ry:10
style id2 stroke-dasharray:3,rx:10,ry:10
style id3 stroke-dasharray:3,rx:10,ry:10
style B stroke:none,fill:#0E44A2,color:#fff
style B2 stroke:none,fill:#0E44A2,color:#fff

{% endmermaid %}
<!-- vale on-->
{% endif %}

{% if include.topology == "hybrid" %}
<!--vale off -->
{% mermaid %}
flowchart TD

A[(Database)]
B(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> Control plane \n #40;{{site.base_gateway}} instance#41;)
C(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 3\n #40;{{site.base_gateway}} instance#41;)
D(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 1\n #40;{{site.base_gateway}} instance#41;)
E(<img src="/assets/images/logos/KogoBlue.svg" style="max-height:20px" class="no-image-expand"/> Data plane 2\n #40;{{site.base_gateway}} instance#41;)

subgraph id1 [Self-managed control plane node]
A---B
end

B --Kong proxy 
configuration---> id2 & id3

subgraph id2 [Self-managed on-premise node]
C
end

subgraph id3 [Self-managed cloud nodes]
D
E
end

style id1 stroke-dasharray:3,rx:10,ry:10
style id2 stroke-dasharray:3,rx:10,ry:10
style id3 stroke-dasharray:3,rx:10,ry:10
style B stroke:none,fill:#0E44A2,color:#fff

{% endmermaid %}
<!-- vale on-->
{% endif %}

{% if include.topology == "traditional" %}

<!--vale off -->
{% mermaid %}
flowchart TD

A[(Database)]
B(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> {{site.base_gateway}} instance)
C(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> {{site.base_gateway}} instance)
D(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> {{site.base_gateway}} instance)

A <---> B & C & D

style B stroke:none,fill:#0E44A2,color:#fff
style C stroke:none,fill:#0E44A2,color:#fff
style D stroke:none,fill:#0E44A2,color:#fff

{% endmermaid %}
<!-- vale on-->
{% endif %}

{% if include.topology == "dbless" %}
<!--vale off -->
{% mermaid %}
flowchart TD

A(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> {{site.base_gateway}} instance)
B(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> {{site.base_gateway}} instance)
C(<img src="/assets/images/logos/kogo-white.svg" style="max-height:20px" class="no-image-expand"/> {{site.base_gateway}} instance)

A2(fa:fa-file kong1.yml)
B2(fa:fa-file kong2.yml)
C2(fa:fa-file kong3.yml)

A2 --> A
B2 --> B
C2 --> C

style A stroke:none,fill:#0E44A2,color:#fff
style B stroke:none,fill:#0E44A2,color:#fff
style C stroke:none,fill:#0E44A2,color:#fff

{% endmermaid %}
<!-- vale on-->
{% endif %}