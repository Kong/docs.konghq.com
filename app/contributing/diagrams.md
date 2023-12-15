---
title: Diagrams in the docs
---

The Kong Docs include built-in support for [mermaid.js](https://mermaid.js.org/). 
This tool lets you build diagrams directly in Markdown without needing any extra diagram software.

We recommend using [Mermaid's online editor](https://mermaid.live) to write your diagrams and see the output side-by-side.
When you're happy with it, copy the code and paste it directly into a docs markdown file.

{:.note}
> **Tip**: If you want to see what the diagram will look like in the docs, use 
[this sample chart with styling config](https://mermaid.live/edit#pako:eNqNlGtv2jAUhv-K5apTkBJEIaWQD5MGaBetY0hUE2zeh0NyAhaOnTlOaYb473NIQGFMUyMlst7zvOfiONnTUEVIAxoLtQs3oA15mjBJ7DUZ_XAmYGAFGbZ-Vtp4tnDGudYoDamUz0quyQcwuIOCLFqV-C5KuHSmikC5qMmd5gaJSlGD4UpmTbb7Sng8WzpT3P2r9rJGHkfOo4KIrECADFGfysw-OfYmGn_lmJky4TlAPO-t9ZE3F49me8RrM7pgtO2VW3AqZNVh57ZtzReid9e59Y7ispHjIsXyvJ1WtuhkdJ7P-hndlpMlfF1PT_KUMEs406_k71DMJc82LUa9Ok-VKTOFwONwmdFqi4FUEpuhsnYV8iLI7JvXUAS9C_Ox7ZgLcTS7jURuqITSwU3k-72uf2Xqvt4luNzOj07ffTj1WhP_53tu3x2eHat-9AAD6tIEdQI8skd6XzoYNRtMkNHALsujzKjb0L-B5rASmJXAvirBaKykeQ8JF0Xl-4jiGQ0PoTafmDn_XWe-u09fGsFU8wR0MS77r4CbOI6vgZHSEeom5sOgj4Nr8glfzAU3vA_7foOzG4NNYDhcdcIOo2X8wOTBbg3kRs0LGdLA6BxdmqeR_XgmHOxhSmgQg8isihE3Sn-pfguhkjFfW28K8rtSJ-rwBw53SvI)
instead, and switch the **Theme** in the top menu to light mode. 

The most commonly used diagram types in the Kong docs are the [flowchart](https://mermaid.js.org/syntax/flowchart.html) and the 
[sequence diagram](https://mermaid.js.org/syntax/sequenceDiagram.html). You can cover most use cases with these two types. 
Follow mermaid.js's docs to learn about node and link styles for each diagram.

If you run into node or link positioning issues in flowcharts, try to rearrange the elements in the chart, 
link them in different ways, or change the [direction](https://mermaid.js.org/syntax/flowchart.html#direction) of the chart. 
You can also use [subgraphs](https://mermaid.js.org/syntax/flowchart.html#subgraphs) to help with positioning.

## Add a diagram to the docs

To add a diagram to a doc, declare it with the `{% raw %}{% mermaid %}{% endraw %}` and `{% raw %}{% endmermaid %}{% endraw %}` tags.

Here's an example of a flowchart with links to the final decisions:

```
{% raw %}{% mermaid %}
flowchart TD
    %% this section defines the node and their labels
    A{Deployment type?}
    B(Traditional mode)
    C(Hybrid mode)
    D(DB-less mode)
    E(Konnect DP)
    F{Enough hardware to 
    run another cluster?}
    G(Upgrade CP first)
    H(Upgrade DP second)
    I([Dual-cluster upgrade])
    J([In-place upgrade])
    K([Rolling upgrade])

    %% this section defines all the connections between nodes
    A --> B
    A --> C
    A --> D
    A --> E
    B ---> F
    C --> G & H
    D ----> K
    E ----> K
    G --> F
    F ---Yes--->I
    F ---No--->J
    H ---> K

    %% this section defines node interactions
    click K "/gateway/latest/upgrade/rolling-upgrade/"
    click I "/gateway/latest/upgrade/dual-cluster/"
    click J "/gateway/latest/upgrade/in-place/"
{% endmermaid %}{% endraw %}
```

The code above creates the following diagram:

{% mermaid %}
flowchart TD
    %% this section defines the nodes
    A{Deployment type?}
    B(Traditional mode)
    C(Hybrid mode)
    D(DB-less mode)
    E(Konnect DP)
    F{Enough hardware to 
    run another cluster?}
    G(Upgrade CP first)
    H(Upgrade DP second)
    I([Dual-cluster upgrade])
    J([In-place upgrade])
    K([Rolling upgrade])

    %% this section defines all the connections between nodes
    A --> B
    A --> C
    A --> D
    A --> E
    B ---> F
    C --> G & H
    D ----> K
    E ----> K
    G --> F
    F ---Yes--->I
    F ---No--->J
    H ---> K

    %% this section defines node interactions
    click K "/gateway/latest/upgrade/rolling-upgrade/"
    click I "/gateway/latest/upgrade/dual-cluster/"
    click J "/gateway/latest/upgrade/in-place/"
{% endmermaid %}


## Styling

All diagrams built with mermaid.js have built-in styling. 
If you need to adjust styling, you can set styles in the diagram definition with 
the `style` tag for nodes, or the `linkStyle` tag for lines.

{:.note}
> **Tip**: Since links (aka lines or connectors) don't have names/IDs like nodes do, you have to style links by numbering them.
It can be difficult to tell what order the links are in, and which connector the style will apply to.
[Mermaid's online editor](https://mermaid.live) lets you test this out in real time, so you can quickly figure out the numbers.
> <br><br>
> To avoid having to reshuffle anything or re-figure out the numbers, 
apply link styling after you have added all the nodes and links to your diagram. 

Here are some basic style tags to know:
* `fill`: The background color of an element
* `stroke`: The line color of an element. For a node, this refers to a border color; for a link, this refers to its line color. 
* `stroke-dasharray`: Turns the border of a node into a dashed line. 
   
   Note that you don't need to do this for links, as you can [specify a dotted link](https://mermaid.js.org/syntax/flowchart.html#dotted-link-with-text)
   by using `-.->` instead of `-->`.

Here's some examples of these styles in use:

```svg
style API stroke:none
# Removes the border from the API node

style DBX stroke-dasharray:3
# Turns the border of the DBX node into a dashed line

style Admin fill:none,stroke:none,color:#d44324
# Removes the fill and border of the admin node and changes the text colour to the hex code above

linkStyle 4,7 stroke:#d44324,color:#d44324
# Changes the line and text color of the 4th and 7th connectors in the diagram

linkStyle 3,6,9 stroke:#b6d7a8
# Changes the line color of the 3rd, 6th, and 9th connectors in the diagram
```

These styles are all used to create the following diagram:

{% navtabs %}
{% navtab Diagram %}
{% mermaid %}
flowchart TD
    DBX[(Current
    database)]
    DBY[(New 
    database)]
    CPX(Current 
    {{site.base_gateway}} X)
    Admin(No admin 
    write operations)
    Admin2(No admin 
    write operations)
    CPY(New 
    {{site.base_gateway}} Y)
    LB(Load balancer)
    API(API requests)

    API --> LB & LB & LB & LB
    Admin2 -."X".- CPX
    LB -.90%.-> CPX
    LB --10%--> CPY
    Admin -."X".- CPY
    CPX -.-> DBX
    CPY --pg_restore--> DBY

    style API stroke:none
    style DBX stroke-dasharray:3
    style CPX stroke-dasharray:3
    style Admin fill:none,stroke:none,color:#d44324
    style Admin2 fill:none,stroke:none,color:#d44324
    linkStyle 4,7 stroke:#d44324,color:#d44324
    linkStyle 3,6,9 stroke:#b6d7a8
{% endmermaid %}

{% endnavtab %}
{% navtab Source code of diagram %}

```
{% raw %}{% mermaid %}
flowchart TD
    DBX[(Current
    database)]
    DBY[(New 
    database)]
    CPX(Current 
    {{site.base_gateway}} X)
    Admin(No admin 
    write operations)
    Admin2(No admin 
    write operations)
    CPY(New 
    {{site.base_gateway}} Y)
    LB(Load balancer)
    API(API requests)

    API --> LB & LB & LB & LB
    Admin2 -."X".- CPX
    LB -.90%.-> CPX
    LB --10%--> CPY
    Admin -."X".- CPY
    CPX -.-> DBX
    CPY --pg_restore--> DBY

    style API stroke:none
    style DBX stroke-dasharray:3
    style CPX stroke-dasharray:3
    style Admin fill:none,stroke:none,color:#d44324
    style Admin2 fill:none,stroke:none,color:#d44324
    linkStyle 4,7 stroke:#d44324,color:#d44324
    linkStyle 3,6,9 stroke:#b6d7a8
{% endmermaid %}{% endraw %}
```
{% endnavtab %}
{% endnavtabs %}