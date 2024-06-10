---
title: Get started with AI Gateway
content-type: tutorial
book: get-started
chapter: 7
---

The [AI Gateway](/gateway/{{page.release}}/ai-gateway/) is built using {{site.base_gateway}}'s standard plugin model. 
The AI plugins are bundled  with {{site.base_gateway}} as of version 3.6.x. 
This means you can deploy the AI Gateway capabilities by following the documented configuration 
instructions for [each plugin](/hub/?category=ai). 

To help you get started quickly, we have provided a script that automates the task of 
deploying a {{site.base_gateway}} configured as an AI Gateway to a Docker container, 
allowing you to evaluate the core AI provider capabilities before exploring the full suite of AI plugins.

The quickstart script supports deploying {{site.base_gateway}} on {{site.konnect_product_name}} or 
in traditional mode on Docker only.

{:.note}
> **Note:**
> Running this script prompts you for AI Provider API Keys which are used to configure authentication with
> hosted AI providers. These keys are only passed to the {{site.base_gateway}} Docker container and are 
> not otherwise transmitted outside the host machine.

1. Run AI Gateway with the interactive `ai` quickstart script:

    ```sh
    curl -Ls https://get.konghq.com/ai | bash
    ```

2. Configure the deployment to target {{site.konnect_product_name}} or Docker only and configure your
   desired AI Provider API keys:

    ```sh
    ...
    Do you want to deploy on Kong Konnect (y/n) y
    ...
    Provide a key for each provider you want to enable and press Enter.
    Not providing a key and pressing Enter will skip configuring that provider.

    → Enter API Key for OpenAI    :
    ...
    ```

3. Once the AI Gateway is deployed, you will see information displayed to help you evaluate the AI proxy 
plugin behavior. For example, the script will output a sample command helping you route a chat request
to OpenAI:

    ```sh
    =======================================================
     ⚒️                                 Routing LLM Requests
    =======================================================
    
    Your AI Gateway is ready. You can now route AI requests
    to the configured AI providers. For example to route a
    chat request to OpenAI you can use the following
    curl command:
    
    curl -s -X POST localhost:8000/openai/chat \
     -H "Content-Type: application/json" -d '{
       "messages": [{
       "role": "user",
       "content": "What is Kong Gateway?"
     }] }'
    ```

4. Finally, the script will display information about deployment
files it generates, which can be used for future AI Gateway configurations. 

    ```sh
    =======================================================
     ⚒️                What is next with the Kong AI Gateway
    =======================================================
    
    This script demonstrated the installation and usage
    of only one of the many AI plugins that Kong Gateway
    provides (the 'ai-proxy' plugin).
    
    See the output directory to reference the files
    used during the installation process and modify for
    your production deployment.
    ℹ /tmp/kong/ai-gateway
    ```

{:.note}
> **Note:**
> By default, local models are configured on the endpoint `http://host.docker.internal:11434`,
> which allows {{site.base_gateway}} running in Docker to connect to the host machine. 

## More information
* [Learn about AI Gateway](/gateway/{{page.release}}/ai-gateway/)
* [AI Gateway plugins](/hub/?category=ai)
