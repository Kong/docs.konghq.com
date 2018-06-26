---
title: Accessing Your Kong License File
---
> If you are a Free Trial User please skip to the "Free Trial Users" section below

# Accessing your License File

Your license file can be found along with your Kong EE installation package in Bintray. To access Bintray, login here:
(https://bintray.com/login?forwardedFrom=%2Fkong%2F)

> If you are unsure of your Bintray credentials please reach out to your CSE for assistance or contact <support@konghq.com>

Once inside Bintray, you should see a new repository listed with the same name as your company. Clicking on that link will 
take you to your repository overview page, with your license file inside.

![](/assets/images/docs/ee/access-bintray-license.png)

Click on the link labeled "license", and then navigate to the "files" tab:

![](/assets/images/docs/ee/access-bintray-license-files.png)

You should see a file listed "license.json". Clicking on the filename will start the file download.

> Don't see a license file in Bintray? Contact your CSE for assistance.

Alternatively, you can run the following command in your terminal to download the license file:

```bash
curl -L <u$username>@kong<$api-key>
"https://kong.bintray.com/<$repo-name>/license.json" -o <file.ext>
```

> Please note: This command requires your Bintray API key, not your account password. Once logged into Bintray, you can find your API key by visiting (https://bintray.com/profile/edit) and clicking "API Key" in the menud. Please contact your CSE or <support@konghq.com> if you need assistance accessing your API key.

### Free Trial Users

If you are a Free Trial user a link to your license file can be found in the Download and Install Instructions email sent immediately after signing up for your free trial.

> If you did not receive this email or would like a new link to your license file - please email <support@konghq.com>

**If you are unsure of how to setup your license file, please see the
[Licensing] (/enterprise/0.32-x/getting-started/licensing/) Guide**