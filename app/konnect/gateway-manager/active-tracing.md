---
title: Active Tracing - Debugging issues in Dataplanes
content_type: reference
---

The Active Tracing feature allows Control Plane Administrators to initiate "deep tracing" sessions in selected Dataplanes. During an active tracing session, the selected Dataplane records Open Telemetry compatible Traces with very detailed spans covering the entire request and response lifecycle for all requests that match a supplied sampling criteria. These traces are pushed up to Konnect where they can inspected using the Konnect builtin span viewed. No additional instrumentation or telemetry technology is needed for generating these traces. 

"Active Tracing" traces are only generated during an Active-Tracing session. These traces cannot be generated with 3rd party telemetry software. "Active Tracing" can have an impact on throughput under heavy load conditions. Active-Tracing itself adds neglible latency to request-response processing under normal load conditions.

List of spans and associated attributes:
<table>
  <thead>
    <th>Span Name</th>
    <th>Note</th>
  </thead>
  <tbody>
    <tr>
      <td>kong</td>
      <td>root span</td>
    </tr>
  </tbody>
</table>


