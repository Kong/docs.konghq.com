---
nav_title: Using the AI RAG Injector plugin
title: Using the AI RAG Injector plugin
---
## Prerequisites

- Create a service and a route.
- Start a [Redis-Stack](https://redis.io/docs/latest/) instance in your environment. 
   - Redis-compatible databases (for example, MemoryDB) are not supported
   - PgVector is supported

You can now create the AI RAG Injector plugin at the global, service, or route level, using the following examples.

## Examples

The following examples show how to configure the AI RAG Injector plugin, and the expected behavior when making requests.

### 1. Configure the AI RAG Injector plugin
Configure the AI RAG Injector plugin with the AI Proxy Advanced plugin:
```yaml
_format_version: '3.0'
services:
- name: ai-proxy
  url: http://localhost:65535
  routes:
  - name: openai-chat
    paths:
    - /
plugins:
- name: ai-proxy-advanced
  config:
    targets:
    - logging:
        log_statistics: true
      route_type: llm/v1/chat
      model:
        name: gpt-4o
        provider: openai
        options:
          max_tokens: 512
          temperature: 1.0

- name: ai-rag-injector
  id: 3194f12e-60c9-4cb6-9cbc-c8fd7a00cff1
  config:
    inject_template: |
      Only use the following information surrounded by <CONTEXT></CONTEXT>to and your existing knowledge to provide the best possible answer to the user.
      <CONTEXT><RAG RESPONSE></CONTEXT>
      User's question: <PROMPT>
    fetch_chunks_count: 5
    embeddings:
      auth:
        header_name: Authorization
        header_value: Bearer <openai_key>
      model:
        provider: openai
        name: text-embedding-3-large
    vectordb:
      strategy: redis
      redis:
        host: <redis_host>
        port: <redis_port>
      distance_metric: cosine
      dimensions: 768
```

### 2. Ingest content to the vector database

Before feeding data to AI Gateway, split your input data into chunks using a tool like `langchain_text_splitters`. Then, you can feed the split chunks into AI Gateway using the Kong Admin API. 
	
The following example shows how to ingest content to the vector database for building the knowledge base. The AI RAG Injector plugin uses the OpenAI `text-embedding-3-large` model to generate embeddings for the content and stores them in Redis.

```bash
curl localhost:8001/ai-rag-injector/3194f12e-60c9-4cb6-9cbc-c8fd7a00cff1/ingest_chunk \
  -H "Content-Type: application/json" \
  -d '{
    "content": "<chunk>"
  }'
```


### 3. Make a AI request to the AI Proxy Advanced plugin

Once vector database has ingested data and built a knowledge base, you can make requests to it. 
For example:

```bash
curl  --http1.1 localhost:8000/chat \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $OPENAI_API_KEY" \
  -d '{
     "messages": [{"role": "user", "content": "What is kong"}]
   }' | jq
```

### 4. Debug the retrieval of the knowledge base

To evaluate which documents are retrieved for a specific prompt, use the following command:

```bash
curl localhost:8001/ai-rag-injector/3194f12e-60c9-4cb6-9cbc-c8fd7a00cff1/lookup_chunks \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "the prompt to debug",
    "exclude_contents": false
  }'
```

To omit the chunk content and only return the chunk ID, set `exclude_contents` to true.

## Update content for ingesting

If you are running {{site.base_gateway}} in traditional mode, you can update content for ingesting by sending a request to the `/ai-rag-injector/:plugin_id/ingest_chunk` endpoint. 

However, this won't work in hybrid mode or {{site.konnect_short_name}} because the control plane can't access the plugin's backend storage.

To update content for ingesting in hybrid mode or {{site.konnect_short_name}}, you can use a script:
 
1. Retrieve the ID of the AI RAG Injector plugin that you want to update.
2. Copy and paste the following script to a local file, for example `ingest_update.lua`:

	```lua
	local embeddings = require("kong.llm.embeddings")
	local uuid = require("kong.tools.utils").uuid
	local vectordb = require("kong.llm.vectordb")
	local cjson = require "cjson"
	local function get_plugin_by_id(id)
	local row, err = kong.db.plugins:select {
		id = id,
	}
	if err then
		return
	end
	if not row then
		return
	end
	return row
	end
	local function ingest_chunk(conf, content)
	local err
	local metadata = {
		ingest_duration = ngx.now(),
	}
	-- vectordb driver init
	local vectordb_driver
	do
		vectordb_driver, err = vectordb.new(conf.vectordb.strategy, conf.vectordb_namespace, conf.vectordb)
		if err then
			return nil, "Failed to load the '" .. conf.vectordb.strategy .. "' vector database driver: " .. err
		end
	end
	-- embeddings init
	local embeddings_driver, err = embeddings.new(conf.embeddings, conf.vectordb.dimensions)
	if err then
		return nil, "Failed to instantiate embeddings driver: " .. err
	end
	local embeddings_vector, embeddings_tokens_count, err = embeddings_driver:generate(content)
	if err then
		return nil, "Failed to generate embeddings: " .. err
	end
	metadata.embeddings_tokens_count = embeddings_tokens_count
	if #embeddings_vector ~= conf.vectordb.dimensions then
		return nil, "Embedding dimensions do not match the configured vector database. Embeddings were " ..
			#embeddings_vector .. " dimensions, but the vector database is configured for " ..
			conf.vectordb.dimensions .. " dimensions.", "Embedding dimensions do not match the configured vector database"
	end
	metadata.chunk_id = uuid()
	-- ingest chunk
	local _, err = vectordb_driver:insert(embeddings_vector, content, metadata.chunk_id)
	if err then
		return nil, "Failed to insert chunk: " .. err
	end
	ngx.update_time()
	metadata.ingest_duration = math.floor((ngx.now() - metadata.ingest_duration) * 1000)
	return metadata
	end
	assert(#args == 3, "2 arguments expected")
	local plugin_id, content = args[2], args[3]
	local plugin = get_plugin_by_id(plugin_id)
	if not plugin then
	ngx.log(ngx.ERR, "Plugin not found")
	return
	end
	local metadata, err = ingest_chunk(plugin.config, content)
	if err then
	ngx.log(ngx.ERR, "Failed to ingest: " .. err)
	return
	end
	ngx.log(ngx.INFO, "Update completed")

	```

3. Run the script from your Kong instance:
 
   ```sh
   kong runner ingest_api.lua <plugin_id> <content_to_update>
   ```
