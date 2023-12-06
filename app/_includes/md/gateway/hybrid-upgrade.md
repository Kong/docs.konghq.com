Hybrid mode comprises of one or more control plane (CP) nodes, and one or more data plane (DP) nodes. 
CP nodes use a database to store Kong configuration data, whereas DP nodes don't, since they get all of the needed information from the CP.
The recommended upgrade process is a combination of different upgrade strategies for each type of node, CP or DP.

The major challenge with a hybrid mode upgrade is the communication between the CP and DP. 
As hybrid mode requires the minor version of the CP to be no less than that of the DP, you must upgrade CP nodes before DP nodes. 
The upgrade must be carried out in two phases:

1. First, upgrade the CP according to the recommendations in the section [Traditional Mode](#traditional-mode), 
while DP nodes are still serving API requests.
2. Next, upgrade DP nodes using the recommendations from the section [DB-less Mode](#db-less-mode). 
Point the new DP nodes to the new CP to avoid version conflicts.

The role decoupling feature between CP and DP enables DP nodes to serve API requests while upgrading CP. 
With this method, there is no business downtime.

Custom plugins (either your own plugins or third-party plugins that are not shipped with {{site.base_gateway}})
need to be installed on both the control plane and the data planes in hybrid mode. 
Install the plugins on the control plane first, and then the data planes.

See the following sections for a breakdown of the options for hybrid mode deployments.

#### Control planes

CP nodes must be upgraded before DP nodes. CP nodes serve an admin-only role and require database support. 
So, you can select from the same upgrade strategies nominated for traditional mode (dual-cluster or in-place), 
as described in figure 2 and figure 3 respectively.

No Admin API write operations can be performed during a CP upgrade.

Upgrading the CP nodes using the [dual-cluster strategy](/gateway/{{page.kong_version}}/upgrade/dual-cluster-upgrade/):

{% mermaid %}
flowchart TD
    DBA[(Current
    database)]
    DBB[(New 
    database)]
    CPX(Current control plane X)
    Admin(No admin 
    write operations)
    CPY(New control plane Y)
    DPX(fa:fa-layer-group Current data plane X nodes)
    API(API requests)

    DBA -.- CPX -..- DPX
    Admin -.X.- CPX & CPY
    DBB --pg_restore--- CPY -..- DPX
    API--> DPX

    style API stroke:none
    style DBA stroke-dasharray:3
    style CPX stroke-dasharray:3
    style Admin fill:none,stroke:none,color:#d44324
    linkStyle 2,3 stroke:#d44324,color:#d44324
{% endmermaid %}

> _Figure 2: The diagram shows a CP upgrade using the dual-cluster strategy._
_The new CP Y is deployed alongside the current CP X, while current DP nodes X are still serving API requests._

Upgrading the CP nodes using the [in-place strategy](/gateway/{{page.kong_version}}/upgrade/in-place-upgrade/):

{% mermaid %}
flowchart 
    DBA[(Database)]
    CPX(Current control plane X \n #40;inactive#41;)
    Admin(No admin \n write operations)
    CPY(New control plane Y)
    DPX(fa:fa-layer-group Current data plane X nodes)
    API(API requests)

    DBA -..- CPX -..- DPX
    Admin -.X.- CPX & CPY
    DBA --"kong migrations up \n kong migrations finish"--- CPY -..- DPX
    API--> DPX

    style API stroke:none
    style CPX stroke-dasharray:3
    style Admin fill:none,stroke:none,color:#d44324
    linkStyle 2,3 stroke:#d44324,color:#d44324
{% endmermaid %}

> _Figure 3: The diagram shows a CP upgrade using the in-place strategy, where the current CP X is directly replaced by a new CP Y._
_DP nodes are gradually diverted to the new CP Y._
_The database is reused by the new CP Y, and the current CP X is shut down once all nodes are migrated._

From the two figures, you can see that DP nodes X remain connected to the current CP node X, or alternatively switch to the new CP node Y.

{{site.base_gateway}} guarantees that new minor versions of CPs are compatible with old minor versions of the DP, 
so you can temporarily point DP nodes X to the new CP node Y.
This lets you pause the upgrade process if needed, or conduct it over a longer period of time. 

After the CP upgrade, cluster X can be decommissioned. You can delay this task to the very end of the DP upgrade.

{:.important}
> This setup is meant to be temporary, to be used only during the upgrade process.
> We do not recommend running a combination of new versions of CP nodes and old versions of DP nodes in a long-term production deployment. 

#### Data planes

Once the CP nodes are upgraded, you can move on to upgrade the DP nodes. 
The only supported upgrade strategy for DP upgrades is the rolling upgrade.

The following diagrams, figure 4 and 5, are the counterparts of figure 2 and 3 respectively. 

Using the [dual-cluster strategy](/gateway/{{page.kong_version}}/upgrade/dual-cluster/) with a 
[rolling upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/) workflow:

{% mermaid %}
flowchart TD
    DBX[(Current \n database)]
    DBY[(New \n database)]
    CPX(Current control plane X)
    CPY(New control plane Y)
    DPX(Current data planes X \n #40;not yet migrated#41;)
    DPY(New data planes Y \n #40;in migration#41;)
    API(API requests)
    LB(Load balancer)
    
    subgraph A
        DBX -.- CPX
        DBY --- CPY
        CPX & CPY -.- DPX
        DPX -.90%..- LB
        CPY --- DPY --10%---- LB
        
    end
    subgraph B
        API --> LB & LB & LB
    end

    linkStyle 6,7 stroke:#b6d7a8
    style CPX stroke-dasharray:3,fill:#eff0f1ff,stroke:#c1c6cdff
    style DPX stroke-dasharray:3
    style DBX stroke-dasharray:3,fill:#eff0f1ff,stroke:#c1c6cdff
    style API stroke:none
    style A stroke:none,color:#fff
    style B stroke:none,color:#fff
{% endmermaid %}

> _Figure 4: The diagram shows a DP upgrade using the dual-cluster and rolling strategies._
_The new CP Y is deployed alongside with the current CP X, while current DP nodes X are still serving API requests._
_DP nodes are gradually switched over to the new CP, until all API traffic is migrated._
_In the image, the background color of the current database and CP X is grey instead of white, signaling that the old CP is already upgraded and might have been decommissioned._

Using the [in-place strategy](/gateway/{{page.kong_version}}/upgrade/in-place-upgrade/) 
strategy with a [rolling upgrade](/gateway/{{page.kong_version}}/upgrade/rolling-upgrade/) workflow:

{% mermaid %}
flowchart 
    DBA(Database)
    CPX(Current control plane X \n #40;inactive#41;)
    CPY(New control plane Y)
    DPX(Current data planes X \n #40;not yet migrated#41;)
    DPY(New data planes Y \n #40;in migration#41;)
    API(API requests)
    LB(Load balancer)

    subgraph A
        DBA -.X.- CPX
        DBA --- CPY
        CPX -.- DPX
        CPY -.- DPX -.90%..- LB
        CPY --- DPY --10%---- LB
    end
    subgraph B
        API --> LB & LB & LB
    end

    linkStyle 0 stroke:#d44324,color:#d44324
    linkStyle 6,7 stroke:#b6d7a8
    style CPX stroke-dasharray:3,fill:#eff0f1ff,stroke:#c1c6cdff
    style DPX stroke-dasharray:3
    style A stroke:none,color:#fff
    style B stroke:none,color:#fff
{% endmermaid %}

> _Figure 5: The diagram shows a DP upgrade using the in-place and rolling strategies._
_The diagram shows one database serving both the current CP X and the new CP Y, while current DP nodes X are still serving API requests._
_DP nodes are gradually switched over to the new CP until all API traffic is migrated._