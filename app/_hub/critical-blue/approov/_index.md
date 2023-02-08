---
name: Approov API Threat Protection
publisher: CriticalBlue Ltd

categories:
  - security

type: integration

desc: Approov ensures that only genuine and unmodified instances of your mobile app can connect to your server or cloud backend

description: |
  With Approov you control what can access your mobile app backend API in a secure and easily deployable manner. Our customers confidently allow API access from iOS and Android devices knowing that Approov will only authenticate legitimate instances of your mobile apps without relying on embedded secrets or keys stored in the app itself.

  This capability prevents misuse of your API by either automated software agents or unauthorized third-party apps, providing the basis for a range of API access management policies.

support_url: https://approov.zendesk.com/hc/en-gb/requests/new

source_code: https://github.com/approov/kong_approov-plugin

kong_version_compatibility:
  community_edition:
    compatible:
      - 1.5.x
      - 1.4.x
      - 1.3.x
  enterprise_edition:
    compatible:
      - 1.5.x
      - 1.3-x
---
