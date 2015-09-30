---
title: PCI DSS Compliance
header_icon: /assets/images/icons/icn-documentation.svg
header_title: PCI DSS Compliance
---

The Payment Card Industry Data Security Standard (PCI DSS) is a set of industry-mandated requirements that apply to any business that handles, processes, or stores credit cards, regardless of the business's size or location.

<div class="alert alert-success">
  <center><stromg>Kong does NOT store any secure financial data by default</stromg></center>
</div>

With a payment processing API served through Kong, depending on your setup, you should consider the following scenarios:

- **Proxying Payment Data:** Falls under the criterion of *"processing"*.

- **Logging & Analytics:** A logging plugin might store credit card data on disk or a remote location *(given your API configuration)*, this would trigger the *"storage"* criterion.

<div class="alert alert-warning">
  <center>PCI DSS compliance is depndant on the configuration and usage of your Kong installation</center>
</div>

You will still need to complete an annual [Self-Assessment Questionnaire (SAQ)](https://www.pcisecuritystandards.org/merchants/self_assessment_form.php) in order to be PCI compliant. There are several different types of SAQs, and a Qualified Security Assessor (QSA) can help you choose the right one for your business and achieve compliance. 

---

<div class="help">
  <img align="left" src="/assets/images/icons/icn-lifesaver.svg"/> We are always willing to help and assist in answering specific questions about your scope of compliance. <a href="mailto:sales@mashape.com">We're Here to Help!</a>
</div>
