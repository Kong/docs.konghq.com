---
name: Kong Heroku app
publisher: Heroku community

categories: 
  - deployment

type: integration

desc: Deploy Kong clusters to Heroku Common Runtime or Private Spaces

description: |
  Easily deploy Kong as a Heroku app. Supports both
  Heroku Common Runtime and Private Spaces. Includes a preset secure-by-default
  loopback proxy to Kong's Admin API.

  Try it for free with a single dyno and a Heroku Postgres hobby dev database.
  Then, scale-up to a cluster of high-performance dynos and a premium database
  plan.
  
support_url: https://github.com/heroku/heroku-kong/issues

source_url: https://github.com/heroku/heroku-kong

license_type: MIT

terms_of_service: This app is a community proof-of-concept, provided "as is", without warranty of any kind.

# COMPATIBILITY
# In the following sections, list Kong versions as array items
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be considered to have "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: # required
  community_edition:
    compatible:
      - 0.14.x
    #incompatible:
  #enterprise_edition: # optional
    #compatible:
    #incompatible:

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

### Deployment

▶️ **Get started at the [GitHub repo](https://github.com/heroku/heroku-kong).**
