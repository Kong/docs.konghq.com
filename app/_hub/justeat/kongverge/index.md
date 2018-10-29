---
name: Kongverge
publisher: Just Eat

categories:
  - deployment

type: integration

desc: A Desired State Configuration tool for Kong.

description: | 
  Kongverge is a command-line tool written in .NET Core 2.1. It is used to configure a kong server by moving its state into sync with the “desired state” given in configuration files.

  Kongverge uses several ‘data transfer objects’ to read from files and write to Kong (and vice versa). For simplicity, the field names on these objects generally match what is present in Kong:

  * KongConfiguration
  * KongRoute 
  * KongService 
  * KongPlugin

  These objects also handle matching - i.e. reconciling the state described by files with the state in Kong, and performing actions in Kong as needed to make them the same. The possible cases for these objects are:

  * Unchanged; The object in Kong is identical to the object in config, so no action is required.
  * Changed; the object in Kong is matched with an object in config, but not all of the properties are  the same. Action is required to update the object in place.
  * New; the object needs to be added to Kong.
  * Deleted; the object needs to be removed from Kong.

support_url: https://github.com/justeat/kongverge/issues

source_url: https://github.com/justeat/kongverge

license_type: Apache-2.0

license_url: https://github.com/justeat/kongverge/blob/master/LICENSE

kong_version_compatibility:
    community_edition:
      compatible:
        - 0.14.x
#      incompatible:
#        - 0.13.x
#        - 0.12.x
#        - 0.11.x
#        - 0.10.x
#        - 0.9.x
#        - 0.8.x
#        - 0.7.x
#        - 0.6.x
#        - 0.5.x
#        - 0.4.x
#        - 0.3.x
#        - 0.2.x
    enterprise_edition:
      compatible:
        - 0.33-x
#      incompatible:
#        - 0.32-x
#        - 0.31-x
#        - 0.30-x
#        - 0.29-x

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# Your headers must be Level 3 or 4 (parsing to h3 or h4 tags in HTML).
# This is represented by ### or #### notation preceding the header text.
###############################################################################
# BEGIN MARKDOWN CONTENT
---

### Documentation

A tutorial, installation steps and further information can be found [here](https://github.com/justeat/kongverge).
