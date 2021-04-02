---
title: OpenAPI GraphQL Support
toc: false
---

![GraphQL](https://doc-assets.konghq.com/studio/1.0/graphql.png)

Kong Studio has auto-detection for GraphQL APIs documented through OpenAPI. To enable auto-detection your GraphQL API must be documented with the following values before generating debugging requests:

* Path must be `/graphql`
* Method must be `POST`
* Request body must be `application/json` and must contain a property `query` with the type `string` 
* Response body must be `application/json`


Below you can see an example of a described GraphQL API endpoint that will trigger auto-detection with a pre-populated request body:

```
paths:
  /graphql:
    post:
      summary: 'My GraphQL API Endpoint'
      description: 'My GraphQL API Endpoint'
      operationId: 'graphql'
      responses:
        200:
          description: 'Successfull Query'
          content: 
            application/json:
              schema:
                type: object
      requestBody:
        content:
          application/json:
            schema:
              type: object
              example: 
                query: >
                  {
                    allFilms {
                      films {
                        title
                      }
                    }
                  }
              properties:
                query:
                  type: string
```

<video width="100%" autoplay loop controls>
 <source src="https://doc-assets.konghq.com/studio/1.0/graphql/graphql-support.mp4" type="video/mp4">
 Your browser does not support the video tag.
</video>

Learn more about debugging with GraphQL in [Insomnia's GraphQL Documentation](https://support.insomnia.rest/article/61-graphql)
