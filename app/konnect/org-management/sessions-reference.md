---
title: Session Durations in Konnect
content_type: reference
---

A login session adheres to the following session duration limits:

* **Individual token duration:** 30 minutes
* **Refresh token duration:** 60 minutes
* **Overall session duration:** 12 hours

This means that a login session can last 12 hours at maximum, as long as the user is active every 60 minutes (for example, reloading a page or configuring something on a page).
After 12 hours, the user will have to log in again.

These limits also apply to sessions initiated through external IdPs.
Currently, session duration limits are not configurable.