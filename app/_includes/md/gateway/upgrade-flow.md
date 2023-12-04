{% mermaid %}
flowchart TD
    A{Deployment type?} --> B(Traditional mode)
    A{Deployment type?} --> C(Hybrid mode)
    A{Deployment type?} --> D(DB-less mode)
    A{Deployment type?} --> E(Konnect DP)
    B ---> F{Enough hardware to 
    run another cluster?}
    C --> G(Upgrade CP first) & H(Upgrade DP second)
    D ----> K([Rolling upgrade])
    E ----> K
    G --> F
    F ---Yes--->I([Dual-cluster upgrade])
    F ---No--->J([In-place upgrade])
    H ---> K
    click K "/gateway/latest/upgrade/rolling-upgrade/"
    click I "/gateway/latest/upgrade/dual-cluster/"
    click J "/gateway/latest/upgrade/in-place/"
{% endmermaid %}

> _Figure 1: Choose an upgrade strategy based on your deployment type. For traditional mode, choose a dual-cluster upgrade if you have enough resources, or an in-place upgrade if you don't have enough resources. For DB-less mode, use a rolling upgrade. For Konnect DPs, use a rolling upgrade. For hybrid mode, use one of the traditional mode strategies for CPs, and the rolling upgrade for DPs._