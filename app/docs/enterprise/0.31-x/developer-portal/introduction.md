---
title: Welcome to the Kong Developer Portal Preview
---

# [Welcome to the Kong Dev Portal Preview](#welcome-to-the-kong-dev-portal)

![alt text](https://konghq.com/wp-content/uploads/2018/03/screen-home.png "Welcome to the Kong Dev Portal")

Thanks for installing or upgrading Kong Enterprise Edition. This document orients you to Kong's built-in Dev Portal functionality and gives you an early view into it so you can get started with customizing your Kong Dev Portal and familiarizing yourself with its promising capabilities.

## Assumptions

* You have installed a recent version of Kong Enterprise Edition that includes Dev Portal functionality.
    * Dev Portal was introduced in Kong EE v0.31
* You are a Kong Admin, and have Super Admin permissions in Kong RBAC.
    * Or, the RBAC feature of Kong EE is disabled.
* You have a OpenAPI Specification v2 or v3 file (also known as a Swagger Specification, or a Swagger file) that documents at least part of your API. 
    * This isn't a strict requirement to get started, but you'll need it soon.

## Glossary

### Key Terms

* **Example Dev Portal** = The set of pages, partials, and specs that are provided in the example Dev Portal files.
* **Handlebars** = [Handlebars](https://handlebarsjs.com/) is a semantic JavaScript templating language.

### Types of Humans

* **Developer** = A human that wants to learn about your APIs by visiting your Dev Portal.
* **Admin** = A human that has access to administer **Kong** functionality.
    * Sometimes we clarify this to also refer to the specific permissions of the admin:
        * **API Gateway Admin** = A human that can administer the **Kong API Gateway**, but not the Dev Portal or Developers.
        * **Dev Portal Admin** = A human that can administer **Dev Portal** content, but not the Developers.
        * **Developer Admin** = A human that can administer **Developers**, their permissions, and their credentials.

* **User** = A human that uses an Application.
    * When OpenID Connect is in use, the **User** is typically involved in delegating permission to **Kong API Gateway** to proxy the requests that are coming from the **Application** that the **User** is using.

### Types of Files

* **Specifications / Specs** = An API specification, in **OpenAPI** (formerly known as Swagger) format. 
* **Partials** = These are Handlebar files made up of HTML, JS, and CSS content that define the look, feel, functionality, and structure of your Dev Portal.
* **Pages** = Pages are Handlebars templates that bring together the previously described **Partial** files and result in pages in your Dev Portal.
* **Loader** = The mechanism which compiles and serves HTML and JavaScript files to the browser when a visitor visits any **Dev Portal** **page**.
    * The Loader requests **Pages**, **Partials** and **Specifications** from Kong, which it uses to render your **Dev Portal** in the visitor's browser.
    * The **Loader** is not modifiable by Admins - instead, customization is performed by modifying **Specifications**, **Partials**, and **Pages**.

### Other Concepts

* **API** = The APIs that are proxied by Kong API Gateway, the APIs that are documented in Dev Portal, and APIs whose usage is monitored by Vitals, etc.
    * Note that this is *not* the **Admin API** of Kong - we consistently refer to that as **Admin API**
* **Consumer** = [A Kong concept and entity.](https://getkong.org/docs/latest/getting-started/adding-consumers/) 
* **Application** = A computer program that calls API(s) proxied by **Kong API Gateway**.
    * This could be a mobile or web front end, an application running on the server of a partner or customer, or an application running within your company. 
