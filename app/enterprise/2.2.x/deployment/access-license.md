---
title: Access Your Kong Gateway (Enterprise) License
---

{{site.ee_product_name}} requires a license file. This guide walks you through how to access your license file.

## Prerequisites

Before you can access your license, you need to sign up for a {{site.konnect_product_name}}
subscription. With this subscription, you will receive access to the Kong
Bintray repository, which contains the necessary license files.

If you have purchased a subscription but haven't received a license file,
contact your sales representative.

## Accessing your license file through a browser

1. Log into [https://bintray.com/](https://bintray.com/login?forwardedFrom=%2Fkong%2F).
If you are unaware of your login credentials, reach out to your CSE and they'll
be able to assist you.

2. Notice that along with {{site.ee_product_name}}, there is a new
repository that has the same name as your company. Click on that repo.

3. In the repo, click on the file called **license**.

    ![bintray-license](/assets/images/docs/ee/access-bintray-license.png)

4. Click into the **Files** section

    ![bintray-license-files](/assets/images/docs/ee/access-bintray-license-files.png)

5. Click any file you want to download.

## Programmatically accessing your license file

For programmatic access you'll need 3 pieces of information:

 - Username (provided through email by your CSE)
 - Repository name (the Bintray repository, visible in the GUI, usually named after your company name)
 - The Bintray API key for the account (see below)

To get the API key follow these steps:

1. [Log into Bintray](https://bintray.com/login?forwardedFrom=%2Fkong%2F).
2. Open the profile settings: click or hover over the username at the top right and select **Edit Profile**.
3. On the left select **API Key**, and if prompted, provide your password again. Click the copy icon to copy the key to your clipboard.

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
