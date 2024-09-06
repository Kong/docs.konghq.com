---
title: GitHub Integration
content-type: reference
---

_Type: External_

The GitHub integration allows you to associate your Service Catalog service to one or more GitHub repositories. 

For each linked Repository, the UI can show a Repository Summary with simple data pulled from the github API, such as number of open issues, open PRs, most recently closed PRs, languages, etc. Also conveniences like being able to get the `git clone ..` command without visiting the github repo.
This information will link to the GitHub repo, PRs etc as applicable

## Authorize the GitHub service

[steps go here]

## Bindable Entities

Entity | Binding Level | Description
-------|---------------|-------------
Repository | Service | A GitHub repository relating to the service


## Discovery FAQs

**Q: Is discovery supported by this integration?**
**A:** Yes.

**Q: Is discovery enabled by default?**
**A:** Yes.

**Q: What bindable entities can be discovered?**
**A:** Repositories.

**Q: What mechanism is used for discovery?**
**A:** Pull/Ingestion model.



