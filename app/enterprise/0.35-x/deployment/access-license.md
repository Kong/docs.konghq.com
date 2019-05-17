---
title: How to Access Your Kong Enterprise License
---

Starting with Kong EE 0.29, Kong requires a license file to start. This guide 
will walk you through how to access your license file. 

**Note:** The following guide only pertains to paid versions of Kong Enterprise. For free trial information, check the email received after signing up.

Log into https://bintray.com/login?forwardedFrom=%2Fkong%2F
If you are unaware of your login credentials, reach out to your CSE and they'll 
be able to assist you.

You will notice that along with Kong Enterprise and Gelato, there is a new 
repository that has the same name as your company. Click on that repo.

In the repo, you'll see 1 file called license. Click on that file.

![](/assets/images/docs/ee/access-bintray-license.png)

Click into the **Files** section

![](/assets/images/docs/ee/access-bintray-license-files.png)

Click any file you would like to download.

Alternatively, you can run this command in your terminal

```bash
curl -L -u<$UserName>@kong<$API_KEY> "https://kong.bintray.com/<$repoName>/license.json" -o <FILE.EXT>
```

> Note: Your UserName and key were emailed to you by your CSE. You will need to get the repo name from the GUI

 

## What Next?

Great! With a license in hand, select [an installation guides](/enterprise/{{page.kong_version}}/deployment/installation/overview) for instructions on how to use it to deploy Kong Enterprise.
