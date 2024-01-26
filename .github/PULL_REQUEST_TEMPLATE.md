
### Description

<!-- What did you change and why? -->
 
<!-- Include any supporting resources, e.g. link to a Jira ticket, GH issue, FTI, Slack, Aha, etc. -->

### Testing instructions

Preview link: <!-- Netlify will generate a preview link after PR is opened. Add links to your edited content here. -->

### Checklist 

- [ ] Review label added <!-- (see below) -->
- [ ] For unreleased versions: [conditional version tags](https://docs.konghq.com/contributing/conditional-rendering/#conditionally-render-content-by-version) added, if applicable.

    For example, if this change is for an upcoming 3.6 release, surround your change in `{% if_version gte:3.6.x %} <content> {% endif_version %}` tags (or `if_plugin_version` tags for plugins). 


<!-- !!! Only Kong employees can add labels due to a GitHub limitation. If you're an OSS contributor, thank you! The maintainers will label this PR for you !!! -->

<!-- When raising a pull request, indicate what type of review you need with one of the following labels:

    review:copyedit: Request for writer review.
    review:general: Review for general accuracy and presentation. Does the doc work? Does it output correctly?
    review:tech: Request for technical review for a docs platform change.
    review:sme: Request for review from an SME (engineer, PM, etc).

At least one of these labels must be applied to a PR or the build will fail.
-->

