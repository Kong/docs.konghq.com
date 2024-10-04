
## Bug fix guidelines
Unfortunately, all software is susceptible to bugs. Kong seeks to remedy bugs through a structured protocol as follows:

* Serious security vulnerabilities are treated with the utmost priority. See [here](/gateway/latest/production/security-update-process/) for our security vulnerability reporting and remedy process, including how to report a vulnerability.

* Bugs which result in production outages or effective non-operation (such as catastrophic performance degradation) will be remedied through high priority bug fixes and provided in patch releases to the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Bugs which prevent the upgrade of a supported version to a more recent supported version will be remedied through high priority bug fixes and provided in the Latest Major/Minor Version Release of all currently supported Major Versions of the software and optionally ported to other versions at Kong’s discretion based on the severity and impact of the bug.

* Other bugs as well as feature requests will be assessed for severity and fixes or enhancements applied to versions at Kong’s discretion depending on the impact of the bug. Typically, these types of fixes and enhancements will only be applied to the most recent Minor Version in the most recent Major Version.

Customers with platinum or higher subscriptions may request fixes outside of the above and Kong will assess them at its sole discretion.

## Deprecation guidelines
From time to time as part of the evolution of our products, we deprecate (in other words, remove or discontinue) product features or functionality. 

We aim to provide customers with at least 6 months’ notice of the removal or phasing out of a significant feature or functionality. We may provide less or no notice if the change is necessary for security or legal reasons, though such situations should be rare. We may provide notice in our documentation, product update emails, or in-product notifications if applicable. 

Once we’ve announced we will deprecate a significant feature or functionality, in general, we won’t extend or enhance the feature or functionality.

## Additional terms
- The above is a summary only and is qualified by Kong’s [Support and Maintenance Policy](https://konghq.com/supportandmaintenancepolicy).
- The above applies to Kong standard software builds only.
