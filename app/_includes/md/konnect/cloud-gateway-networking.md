<!--vale off -->
{% mermaid %}
flowchart LR

A(API or service)
B(API or service)
C(API or service)
D(<img src="/assets/images/icons/third-party/aws-transit-gateway-attachment.svg" style="max-height:32px" class="no-image-expand"/>AWS \n Transit Gateway \n attachment)
E(<img src="/assets/images/icons/third-party/aws-transit-gateway.svg" style="max-height:32px" class="no-image-expand"/> AWS \n Transit Gateway)
F(<img src="/assets/images/icons/third-party/aws-transit-gateway-attachment.svg" style="max-height:32px" class="no-image-expand"/>AWS \n Transit Gateway \n attachment)
G(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-height:32px" class="no-image-expand"/>Konnect \n#40;fully-managed \ndata plane#41;)
H(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-height:32px" class="no-image-expand"/>Konnect \n#40;fully-managed \ndata plane#41;)
I(<img src="/assets/images/logos/konglogo-gradient-secondary.svg" style="max-height:32px" class="no-image-expand"/>Konnect \n#40;fully-managed \ndata plane#41;)
J(fa:fa-wifi \n Internet)

subgraph 1 [User AWS Cloud]
    subgraph 2 [Region]
        subgraph 3 [Virtual Private Cloud #40;VPC#41;]
        A
        B
        C
        end
        A & B & C <--> D
    end
   D<-->E
end

subgraph 4 [Kong AWS Cloud]
    subgraph 5 [Region]
        E<-->F
        F <--private API \n access--> G & H & I
        subgraph 6 [Virtual Private Cloud #40;VPC#41;]
        G
        H
        I
        end
    end
end

G & H & I <--public API \n access--> J

style A stroke:#e07113
style B stroke:#e07113
style C stroke:#e07113
style D stroke:#8c4fff
style E stroke:#8c4fff,fill:#8c4fff,color:#fff
style F stroke:#8c4fff
style 2 stroke:#167eba,color:#167eba,stroke-dasharray:3
style 5 stroke:#167eba,color:#167eba,stroke-dasharray:3
style 3 stroke:#238813,color:#238813,stroke-dasharray:3
style 6 stroke:#238813,color:#238813,stroke-dasharray:3

{% endmermaid %}
<!--vale on-->