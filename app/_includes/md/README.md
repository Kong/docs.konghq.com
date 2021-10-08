# How to manage content in the _includes/md directory

This directory contains text snippets that are shared across multiple docs files. Here's how to manage these files:

## Place files in a product directory

Examples:

- `mesh`
- `plugins-hub`

## Only if you have different versions of the include content

- Content for current version continues to live at the root of the product directory
- Versioned content (for non-current versions only!) lives in a sub-directory named <version_number>

## Learn how to use includes

For guidelines on how to write includes and call them in target topics, see the
[Kong Docs contributing guidelines](https://docs.konghq.com/contributing/includes). 
