---
title: Networking
book: portal
chapter: 1
---

# Networking

Describe information about networking with `PORTAL_GUI_URL`, `PROXY_URL`. How does the Dev Portal uses these values to establish the internal proxy routes, services, and CORS plugins?

Talk about load balancing traffic to dev portal, custom domains, and how the portal URL is calculated if `PORTAL_GUI_URL` isn't set. If it's not set we use the window request URL and append the PORT. 

Cross reference wording from the FAQ as well as the kong.conf.default file.
