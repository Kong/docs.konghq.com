---
title: Vitals in Kong Manager
book: admin_gui
---

For information about how to toggle the Vitals feature and use the Vitals API, 
visit [Kong Vitals](/enterprise/{{page.kong_version}}/admin-api/vitals)

## Vitals Charts

Kong Manager's Vitals charts display the successes and errors of each Kong 
Workspace within a given timespan. This visualization makes it easy for an 
Admin to quickly identify the Workspaces in need of attention from the moment 
they log in.

To see the exact number of errors and successes at a given timestamp, hover 
over coordinates on the chart.

## Overview and Workspace Vitals

Vitals will be on by default, so it will be accessible the first time a Super 
Admin logs in.

Any authorized user will see a large overview of Vitals for the entire Kong 
cluster. Beneath it, each Workspace they have access to will also display their 
respective Vitals.

In addition to the chart with errors and successes, an authorized user will be 
able to see the total number of requests and consumers.

 To see a more detailed chart of the entire Kong cluster, click the "Vitals" 
 link in the top navigation. For a more detailed chart of a particular Workspace, 
 navigate to the Workspace, then hover over the circular chart icon and click 
 "Status Codes". 

⚠️ **IMPORTANT**: If a user does not have access to a Workspace, its Vitals will 
be hidden, and if they do not have access to any Vitals data, the charts will not appear.

## Dashboard

Beneath the Vitals graph, each Workspace will display the most recently added 
services, consumers, and plugins.
