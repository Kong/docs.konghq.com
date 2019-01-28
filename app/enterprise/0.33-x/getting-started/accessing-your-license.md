---
title: How to Access Your Kong Enterprise Edition License
toc: false
---

Starting with Kong EE v .29, Kong requires a license file to start. This guide will walk you through accessing your license file.

Log into https://bintray.com/login?forwardedFrom=%2Fkong%2F
If you are unaware of your login credentials, reach out to your CSE and they'll be able to assist you.

You will notice that along with Kong Enterprise Edition and Gelato, there is a new repository that has the same name as your company. Click on that repo.

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
Great! Now that you have your license, you can follow [this guide](/enterprise/latest/installation/docker) for instructions on how to use it to start Kong EE.
