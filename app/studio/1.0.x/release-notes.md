---
title: Kong Studio 1.0 Release Notes
toc: false
---

## Introduction

Announcing Kong Studio 1.0, our spec-first development tool for APIs leveraging the power of Insomnia! In this release you’ll find the ability to design specifications, sync with git, convert your spec into requests for debugging purposes, and more.

The capability to download Kong Studio is included with your Kong Enterprise plan. To download the latest version of Kong Studio, visit the download page located on [Bintray](https://bintray.com/kong/studio).

## Notable Features

* [OpenAPI Spec Editor](#openapi-spec-editor)
* [GraphQL Support](#graphl-support)
* [Git Sync](#git-sync)
* [Generate Requests from Specs](#generate-requests-from-specs)
* [Deploy To Kong's Developer Portal](#deploy-to-kongs-developer-portal)


### OpenAPI Spec Editor

Kong Studio ships with a built-in editor and includes the features you need for highly productive spec design. Features include navigation and linting of your OpenAPI spec as you design.

[Learn More...](/studio/{{page.kong_version}}/editing-specs)

![OpenAPI Spec Editor](https://doc-assets.konghq.com/studio/1.0/release-notes/openapi-spec-editor.gif)

### Git Sync

Kong Studio is built for the API DevOps lifecycle, where infrastructure and configuration is code. We enable this through tight integration with Git. Regardless of whether you’re using GitHub, Bitbucket, or GitLab, you can import, commit, create branches, swap branches, and more directly from Kong Studio.

[Learn More...](/studio/{{page.kong_version}}/git-sync)

![Git Sync](https://doc-assets.konghq.com/studio/1.0/release-notes/gitsync.gif)


### Generate Requests from Specs

Kong Studio also provides tight integration with the Insomnia core, as you design and edit your specification you can quickly generate and update existing requests directly from the OpenAPI spec editor built into Studio. Upon generating requests you’ll enter the debugging mode, the Insomnia UI you’re already familiar with, and can quickly begin debugging your spec.

[Learn More...](/studio/{{page.kong_version}}/debugging-with-insomnia)

![Debug Specs](https://doc-assets.konghq.com/studio/1.0/release-notes/debug.gif)


### GraphQL Support

Kong Studio will detect GraphQL and automatically format requests and responses.

[Learn More...](/studio/{{page.kong_version}}/graphql)


### Deploy to Kong's Developer Portal

Lastly, and most important is one of the key integrations of Kong Studio. Integration with the Kong Enterprise platform. Directly from within Kong Studio you’ll be able to deploy the OpenAPI spec you’ve been designing and debugging directly to the Kong Developer Portal of your choice. Doesn’t matter what workspace, we’ve got you covered. Made changes and want to update your spec on Kong Developer Portal? We’ve got you covered there too.

[Learn More...](/studio/{{page.kong_version}}/deploy-to-dev-portal)

![Deploy to Dev Portal](https://doc-assets.konghq.com/studio/1.0/release-notes/deploy-to-dev-portal.gif)


### Q&A

#### Can I run Kong Studio & Insomnia side by side?

Yes!

Kong Studio is built for a different use-case than Insomnia, and while it leverages insomnia at it’s core,  we built it so you can run both side-by-side, without issues. This way, you can create the workflow that fits best for you.
