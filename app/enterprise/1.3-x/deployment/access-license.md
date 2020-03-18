---
title: Access Your Kong Enterprise License
toc: false
---

Kong Enterprise requires a license file. This guide walks you through how to access your license file. 

**Note:** The following guide only pertains to paid versions of Kong Enterprise. For free trial information, check the email received after signing up.

Log into [https://bintray.com/login?forwardedFrom=%2Fkong%2F](https://bintray.com/login?forwardedFrom=%2Fkong%2F)
If you are unaware of your login credentials, reach out to your CSE and they'll 
be able to assist you.

You will notice that along with Kong Enterprise, there is a new 
repository that has the same name as your company. Click on that repo.

In the repo, click on the file called **license**.

![bintray-license](/assets/images/docs/ee/access-bintray-license.png)

Click into the **Files** section

![bintray-license-files](/assets/images/docs/ee/access-bintray-license-files.png)

Click any file you would like to download.

## Programmatically accessing your license file

For programmatic access you'll need 3 pieces of information:

 - username (was provided by email by your CSE)
 - repository name (the Bintray repository, visible in the GUI, usually named after your company name)
 - the Bintray API key for the account (see below)

To get the API key follow these steps:

1. [Log into Bintray](https://bintray.com/login?forwardedFrom=%2Fkong%2F)
2. Open the Profile settings (click the username at the top-right and select "Edit Profile")
3. On the left select "API Key", and provide your password again

To access the license:

```bash
BINTRAY_USERNAME="your_user_name" && \
BINTRAY_REPO="your_repo_name" && \
BINTRAY_APIKEY="your_api_key" && \
curl -L -u"$BINTRAY_USERNAME:$BINTRAY_APIKEY" "https://kong.bintray.com/$BINTRAY_REPO/license.json"
```
If successful, it will display the downloaded license.

To use the license either as a file or as a variable, replace the last command with either of these examples:

- To download the license file as `license.json`:

    ```bash
    curl -L -u"$BINTRAY_USERNAME:$BINTRAY_APIKEY" "https://kong.bintray.com/$BINTRAY_REPO/license.json" -o license.json
    ```

- To export the license as an environment variable:

    ```bash
    export KONG_LICENSE_DATA=$(curl -L -u"$BINTRAY_USERNAME:$BINTRAY_APIKEY" "https://kong.bintray.com/$BINTRAY_REPO/license.json")
    ```


 
