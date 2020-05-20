---
title: Kong Studio 1.2.x Release Notes
toc: false
---

# Generate Config, Linter Panel, and more!

A new year, a new release of Kong Studio! The team has been hard at work to deliver some big updates in this release around configuration and validation, as if you couldn’t tell from the title! Let’s get right into it.

# What’s New?

## Generate Kong Declarative Config

You can now generate Kong Declarative Config from your specifications directly from inside of Kong Studio. Click the “Generate Config” button in the Editor view and let us handle the hard work. We even added a button there so you can quickly copy it to your clipboard. Amazing. 

[Learn more.](/studio/{{page.kong_version}}/dec-conf-studio)

![Declarative config](https://doc-assets.konghq.com/studio/1.2/declarative-config.gif)

## Added a Linter Panel

We’ve aggregated all of your linter warnings and errors into one location at the bottom of the code editor to make it easier to see what’s wrong with your specification.

[Learn more.](/studio/{{page.kong_version}}/linting)

![Lint warnings](https://doc-assets.konghq.com/studio/1.2/lint-warnings.gif)

## Disable previewing links in responses

You can disable URLs from becoming hyperlinks in the response pane in the Explorer view. No more accidentally clicking on a link when you’re just trying to copy-paste. Nice.

![Disable links](https://doc-assets.konghq.com/studio/1.2/disable-links.gif)

## Added ability to bulk edit query parameters

Now you can edit queries in bulk without having to click each individual input field. It’s what you’ve *always* wanted but didn’t know you did, until *now*.

![Bulk query](https://doc-assets.konghq.com/studio/1.2/bulk-query.gif)

## Bug Fixes

* Fixed an issue where theme styling caused problems with the Preview Pane OAuth dialog

Want to read the full [changelog](https://docs.konghq.com/studio/changelog/)?
