---
title: Debugging Spec Files with Insomnia
toc: false
---

### Introduction

Kong Studio leverages the powerful open source debugging tool [Insomnia](https://insomnia.rest).
Once you've designed your spec, you can generate requests and fully test and debug your spec right inside Kong Studio.


## Debugging with Insomnia

1. Open the **Workspace** of the spec you wish to test.

2. In the upper right hand corner click **Test**

![Test](https://doc-assets.konghq.com/studio/1.0/debugging/test.png)

3. Kong Studio will prompt you to "Generate Requests", note that this will overwrite any existing test activity. Click **Generate Requests** to agree.

![Generate Requests](https://doc-assets.konghq.com/studio/1.0/debugging/generate-requests.png)

Kong Studio will generate the sample requests from the spec file and display them in the **Debug** view

![Sample Requests](https://doc-assets.konghq.com/studio/1.0/debugging/sample-requests.png)

4. Click on a request on the **Workspace sidebar** to populate that request into the **Request Panel**

![Request Panel](https://doc-assets.konghq.com/studio/1.0/debugging/request-panel.png)

5. Click **Send** to test the request. The response will render in the **Response Panel**

![Response Panel](https://doc-assets.konghq.com/studio/1.0/debugging/response-panel.png)

To lean more about generating requests and to full leverage the power of Insomnia, head over to [Insomnia's Documentation](https://support.insomnia.rest/)
