---
title: Kong Studio Changelog
layout: changelog
---

### 1.2.0
**Released on 1/17/2020**

#### Added

* Added the ability to generate Declarative Configuration for Kong Gateway.
* Added new Linter Tray in the Editor view that shows all validation and linting errors associated with your currently open document.
* Added setting to disable clickable links in Explorer responses.
* Added ability to bulk-edit query parameters.
* Added support for proxy settings to apply to all network requests.

#### Changed

* Improved Editor performance by performing updates less frequently.
* Improved support for dark themes when previewing documents.

#### Fixed

* Fixed an issue where theme styling was causing issues with the Preview Pane OAuth dialog.

### 1.1.1
**Released on 12/13/2019**

#### Added

* Added support for importing security scheme blocks when importing OpenAPI v3.
* Added ability to use `X-HTTP-Method-Override` header to switch to GraphQL.
* Added support for code folding persistence when switching between requests.
* Added right click context menu to explorer sidebar.
* Added option to download prettified JSON response.
* Added support for importing WSDL.

#### Changed

* Changed underlying navigation keys to avoid issues when duplicate keys exist.
* Changed GraphQL to wait until schema is fetched before linting.
* Changed renaming requests behavior to prompt for new name.

#### Fixed

* Fixed an issue where duplicate paths / keys in a spec caused the editor to crash without ability to recover.
* Fixed a potential white screen issue when creating a workspace.
* Fixed Github requests from erring during OAuth flow by adding a User Agent header.
* Fixed Git Sync for Windows.
* Fixed issue where specs uploaded with a forward slash in the beginning of the filename threw errors.


### 1.1.0
**Released on 11/27/2019**

#### Added

* Added Live Preview functionality while editing OpenAPI specs to Editor view.
* Added Import by Clipboard functionality to import dropdown under Data settings.
* Added new dark theme to compliment existing light theme.
* Added ability to scroll to the Editor Navigation.
* Added support for Enums to GraphQL documentation explorer.
* Added automatic parsing of query parameters for CURL import.

#### Changed

* Changed activity bar icons
* Changed activity bar active and hover states for improved visual cue.
* Changed underlying parsing of the OpenAPI specification for Editor Navigation.
* Changed responses in request history to be grouped by time.

#### Fixed

* Fixed an issue where Editor Navigation didn’t support empty arrays / objects.
* Fixed an issue where Editor Navigation would only navigate to the first key found.
* Fixed an issue where Editor Navigation wouldn’t navigate properly to paths.
* Fixed an issue where Editor Navigation wouldn’t navigate to array elements.
* Fixed an issue where OpenAPI specifications with lots of members caused the Git Sync bar to disappear.
* Fixed an issue where OAuth 2.0 login dialog was not using correct User-Agent.
* Fixed an issue where empty OpenAPI property objects caused import to fail.

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

Initial Release.
