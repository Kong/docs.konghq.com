This plugin offers extensive options for configuring tracing header propagation, providing a high degree of flexibility.
Users can freely customize which headers are used to extract and inject tracing context. Additionally, they have the ability to configure headers to be cleared after the tracing context extraction process, enabling a high level of customization.

<!--vale off-->
{% mermaid %}
flowchart LR
   id1(Original Request) --> Extract
   id1(Original Request) -->|"headers (original)"| Extract
   id1(Original Request) --> Extract
   subgraph ide1 [Headers Propagation]
   Extract --> Clear
   Extract -->|"headers (original)"| Clear
   Extract --> Clear
   Clear -->|"headers (filtered)"| Inject
   end
   Extract -.->|extracted ctx| id2((tracing logic))
   id2((tracing logic)) -.->|updated ctx| Inject
   Inject -->|"headers (updated ctx)"| id3(Updated request)
{% endmermaid %}
<!--vale on-->

The examples below demonstrate how the propagation configuration options can be used to achieve various use cases.

#### Extract, clear and inject
- Extract the tracing context using order of precedence: `w3c` > `b3` > `jaeger` > `ot` > `aws` > `datadog`
- Clear `b3` and `uber-trace-id` headers after extraction, if present in the request
- Inject the tracing context using the format: `w3c`

```yaml
- config:
    propagation:	
      extract: [ w3c, b3, jaeger, ot, aws, datadog ]
      clear: [ b3, uber-trace-id ]
      inject: [ w3c ]
```

#### Multiple injection
- Extract the tracing context from: `b3`
- Inject the tracing context using the formats: `w3c`, `b3`, `jaeger`, `ot`, `aws`, `datadog`, `gcp`

```yaml
- config:
    propagation:	
      extract: [ b3 ]
      inject: [ w3c, b3, jaeger, ot, aws, datadog, gcp ]
```

#### Preserve incoming format
- Extract the tracing context using order of precedence: `w3c` > `b3` > `jaeger` > `ot` > `aws` > `datadog`
- Inject the tracing context **in the extracted header type**
- Default to `w3c` for context injection if none of the `extract` header types were found in the request

```yaml
- config:
    propagation:	
      extract: [ w3c, b3, jaeger, ot, aws, datadog ]
      inject: [ preserve ]
      default_format: "w3c"
```

**Note:** `preserve` can be used with other formats, to specify that the incoming format should be preserved in addition to the others:

```yaml
- config:
    propagation:	
      extract: [ w3c, b3, jaeger, ot, datadog ]
      inject: [ aws, preserve, datadog ]
      default_format: "w3c"
```

#### Ignore incoming headers
- No tracing context extraction
- Inject the tracing context using the formats: `b3`, `datadog`

```yaml
- config:
    propagation:	
      extract: [ ]
      inject: [ b3, datadog ]
```

**Note:** Some header formats specify different trace and span ID sizes. When the tracing context is extracted and injected from/to headers with different ID sizes, the IDs are truncated or left-padded to align with the target format.