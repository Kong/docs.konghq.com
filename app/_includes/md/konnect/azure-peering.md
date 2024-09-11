<!--vale off -->
{% mermaid %}
flowchart LR

A(API or service)
B(API or service)
C(API or service)

G(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-height:32px" class="no-image-expand"/>Konnect \n#40;fully-managed \ndata plane#41;)
H(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-height:32px" class="no-image-expand"/>Konnect \n#40;fully-managed \ndata plane#41;)
J(fa:fa-wifi \n Internet)

subgraph 1 [User Azure Cloud]
    subgraph 2 [Region]
        subgraph 3 [Virtual Network #40;VNET#41;]
        A
        B
        C
        end
    end
end
3 <--VNET Peering \n Private API Access--> 6

subgraph 4 [Kong Azure Cloud]
    subgraph 5 [Region]
        subgraph 6 [Virtual Network #40;VNET#41;]
        G
        H
        end
    end
end

G & H <--public API \n access--> J

style A stroke:#e07113
style B stroke:#e07113
style C stroke:#e07113
style 2 stroke:#167eba,color:#167eba,stroke-dasharray:3
style 5 stroke:#167eba,color:#167eba,stroke-dasharray:3
style 3 stroke:#238813,color:#238813,stroke-dasharray:3
style 6 stroke:#238813,color:#238813,stroke-dasharray:3


{% endmermaid %}
<!--vale on-->