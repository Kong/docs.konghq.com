---
title: Git Sync with Kong Studio
---


## Introduction

Kong Studio is a collaborative tool for creating, managing, and sharing API specifications. This collaboration is built on the ubiquitous version control system [Git](https://git-scm.com/), which was chosen to allow Kong Studio to fit within the existing editing, review, testing, and deployment workflows that companies and teams already have in place for source code.

To demonstrate the various features of Git Sync, we will be using the demo Swagger Petstore API.


![Introduction](https://doc-assets.konghq.com/studio/1.0/git-sync/01-intro.png)


### Remote Repository Settings

To configure a repository, click the “Setup Git Sync” button at the bottom of the sidebar.  

* **Git URI** – The URI of the git repository you wish to connect to. Note, only `https` URLs are supported.
* **Author Name/Email** – Git author metadata that will be stored with each commit
* **Authentication Token** – The token needed to authenticate with remote repository provider (GitHub, Bintray, etc)

![Repo Settings](https://doc-assets.konghq.com/studio/1.0/git-sync/02-repo-settings.png)

Once complete, click “Done” and the repository settings will be persisted for future operations. Author details and token can be updated after if needed.


### Cloning an Existing Repository

If a team member has already pushed a Studio project to a remote repository, it can be cloned via the main menu in the top-left of the application. Here, you will see the same Repository Settings dialog to configure remote access.

<div class="alert alert-warning">
<strong>Note:</strong> Studio does not currently support repositories that contain files outside the root ".studio" folder.
</div>

In order to clone, the repository must exist and also contain the root  `.studio/` folder. 

![Cloning a Repo](https://doc-assets.konghq.com/studio/1.0/git-sync/03-clone-repo.png)


### Commits and History

A new commit can be created via the git menu at the bottom of the sidebar. 

In the following example, you can see we are creating a new commit and adding the API Spec object. The descriptive message that will be saved in Git is entered in the input area. Since this is our first commit, all objects are currently "unversioned" (not yet saved in the repository).

![Create a new commit](https://doc-assets.konghq.com/studio/1.0/git-sync/04-comits-and-history.png)

Once we create the commit, we can view it in the repository history.

![View it in the repo history](https://doc-assets.konghq.com/studio/1.0/git-sync/05-commits-history.png)

And once we have committed resources to the repository, the next time we modify them they will appear as modified objects instead of unversioned and will be automatically selected as candidates for the commit.

![Modify Object](https://doc-assets.konghq.com/studio/1.0/git-sync/06-commits-history.png)


### Pushing Changes Remotely

Commits only exist locally when created. In order to collaborate, changes need to be pushed to the remote repository.

![Push Changes](https://doc-assets.konghq.com/studio/1.0/git-sync/07-pushing-changes-remotely.png)


### Managing Branches

When working with Git, it is recommended to perform changes in separate branches. This has two benefits:


1. Reduces the chances of merge conflicts when team members are making frequent changes
2. Supports a **pull-request workflow** where team members can leave feedback before merging

Local branches can be created from the branch management dialog. This dialog presents both local branches and remote branches. Note, remote branches will only appear if they do not already exist locally.

![Managing Branches](https://doc-assets.konghq.com/studio/1.0/git-sync/08-managing-branches.png)


### Pushing Changes

Commits and branches only exist locally when created. A push needs to be done to share the commits and history of a branch remotely.

![Pushing Changes](https://doc-assets.konghq.com/studio/1.0/git-sync/09-pushing-changes.png)

### Pulling Changes

If a team member makes a change to the remote repository, they will need to be “pulled” down in order to use locally. Pulling will fetch the current branch from the remote repository and merge any changes locally.


![Pulling Changes](https://doc-assets.konghq.com/studio/1.0/git-sync/10-pulling-changes.png)


### Conflict Resolution

Studio does not currently support the ability to resolve conflicts. If changes were made locally *and* remotely, a pull may fail.

Here are some strategies to help with conflicts:

* Each team member should make changes in a separate branch to avoid conflicts. Changes should be merged into `master` once reviewed and approved by other team members (eg. GitHub pull request)
* If a conflict occurs on pull, delete the branch locally and re-fetch it from the branches dialog 
