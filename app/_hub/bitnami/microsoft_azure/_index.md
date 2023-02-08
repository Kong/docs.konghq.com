---
# This template is maintained by @marcosbc from Bitnami
name: Kong on Microsoft Azure Certified
publisher: Bitnami

categories:
  - deployment

type: integration

desc: The Bitnami Kong Stack provides a one-click install solution for Kong
description: |
  The Bitnami Kong Stack provides a one-click install solution for Kong.
  Bitnami certifies that the images are secure, up-to-date, and packaged using
  industry best practices.

  Looking for Kong with fault tolerance and support for heavier workloads? Try
  Bitnami’s Kong Cluster solution, which uses the native cloud provider APIs to
  deploy a multi-node, load-balanced Kong cluster and an additional Cassandra
  cluster for data storage.

support_url: https://bitnami.com/support/azure

# license_type: Apache-2.0
  # (Optional) For open source, use the abbreviations in parentheses at:
  # https://opensource.org/licenses/alphabetical

license_url: https://bitnami.com/azure/terms
  # (Optional) Link to your custom license.

# privacy_policy:
  # (Optional) If you have a custom privacy policy, place it here

privacy_policy_url: https://bitnami.com/privacy
  # (Optional) Link to a remote privacy policy

# terms_of_service:
  # (Optional) Text describing your terms of service.

terms_of_service_url: https://bitnami.com/terms-of-use
  # (Optional) Link to your online TOS.

# COMPATIBILITY
# In the following sections, list Kong versions as array items.
# Versions are categorized by Kong edition and their known compatibility.
# Unlisted Kong versions will be considered to have "unknown" compatibility.
# Uncomment at least one of 'community_edition' or 'enterprise_edition'.
# Add array-formatted lists of versions under their appropriate subsection.

kong_version_compatibility: # required
  community_edition: # optional
    compatible:
        - 0.14.x
    #incompatible:
  # enterprise_edition: # optional
    # compatible:
        # - 0.34-x
        # - 0.33-x
        # - 0.32-x
    #incompatible:

###############################################################################
# END YAML DATA
# Beneath the next --- use Markdown (redcarpet flavor) and HTML formatting only.
#
# The remainder of this file is for free-form description, instruction, and
# reference matter.
# If you include headers, your headers MUST start at Level 2 (parsing to
# h2 tag in HTML). Heading Level 2 is represented by ## notation
# preceding the header text. Subsequent headings,
# if you choose to use them, must be properly nested (eg. heading level 2 may
# be followed by another heading level 2, or by heading level 3, but must NOT be
# followed by heading level 4)
###############################################################################
# BEGIN MARKDOWN CONTENT
---
