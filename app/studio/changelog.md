---
title: Kong Studio Changelog
layout: changelog
---

### 1.1.0
**Released on 11/27/2019**

#### Added

* Added Live Preview functionality while editing OpenAPI specs to Editor view
* Added Import by Clipboard functionality to import dropdown under Data settings
* Added new dark theme to compliment existing light theme
* Added ability to scroll to the Editor Navigation
* Added support for Enums to GraphQL documentation explorer
* Added automatic parsing of query parameters for CURL import

#### Changed

* Changed activity bar icons
* Changed activity bar active and hover states for improved visual cue
* Changed underlying parsing of the OpenAPI specification for Editor Navigation
* Changed responses in request history to be grouped by time

#### Fixed

* Fixed an issue where Editor Navigation didn’t support empty arrays / objects.
* Fixed an issue where Editor Navigation would only navigate to the first key found.
* Fixed an issue where Editor Navigation wouldn’t navigate properly to paths.
* Fixed an issue where Editor Navigation wouldn’t navigate to array elements.
* Fixed an issue where OpenAPI specifications with lots of members caused the Git Sync bar to disappear
* Fixed an issue where OAuth 2.0 login dialog was not using correct User-Agent
* Fixed an issue where empty OpenAPI property objects caused import to fail

### 1.0.1
**Released on 11/20/2019**

#### Changes
* Added a space between sentences after successful spec upload during Deploy to Developer Portal workflow.
* Added ability to delete the local master branch to mitigate merge conflicts.
* Changed icon for Microsoft Windows to render properly at lower resolutions.

#### Fixes
* Fixed an issue where files outside of the .studio folder were causing clones and pulls to fail.
* Fixed an issue where git push would silently fail, now upon failure it notifies the user and displays an error message.
* Fixed an issue where the Developer Portal link after uploading a specification was not working.
* Fixed an issue where the Deploy to Developer Portal modal would not close properly when clicking outside the modal.
* Fixed an issue where the “Go Back” button during spec naming on Deploy to Developer Portal did not work.


### 1.0
**Released on 11/11/2019**

Initial Release
