---
title: Community
no_version: true
---

This section contains information on how to contribute using our docs-as-code approach. You may also be interested in [Community Expectations](/contributing/community-expectations/) and [Hackathons](/contributing/hackathons/). 

## How to contribute to docs-as-code as a beginner

Welcome to our introduction on how to contribute to Kong Docs using our docs-as-code approach. This tutorial is designed for first-time contributors who want to get started with simple tasks to boost their confidence in tooling, add to their portfolio, and join our international community. 

We house all our docs code on GitHub, a code versioning platform that allows people all over the world to collaborate on projects. You'll need a [GitHub](https://github.com/) account, so if you don't already have one, now's the time to sign up. 

Once you have a GitHub account, head over to our [docs.konghq.com](https://github.com/Kong/docs.konghq.com) project. 

The first thing we’re going to do is look over the README. Read through the intro section for some basic information about our project. 

### Basic setup

To contribute using our docs-as-code approach, you'll need:

* A code editor like [VScode](https://code.visualstudio.com/) or [Atom](https://atom.io/).
* Basic Git knowledge, see [Git/GitHub Resources](/contributing/#gitgithub-resources).
* A local copy of our repository. On [our main repository page](https://github.com/Kong/docs.konghq.com), click the `Code` dropdown button and copy the `ssh` URL. In your terminal, run `git clone {SSH_URL}`, replacing `{SSH_URL}` with the URL you copied from the `Code` dropdown button. 
* To know the difference between a PR and an Issue. PR stands for Pull Request or Please Review. It’s different from an Issue in that an Issue is a statement of something that needs attention, while a PR attempts to resolve something. So, an Issue is an idea and a PR is an action. 

From here, determine which applies to you:

* [I know what I want to contribute](#i-know-what-i-want-to-contribute).
* [I need ideas on what to contribute](#i-need-ideas-on-what-to-contribute).

### I know what I want to contribute

Great! Let's first check to see if someone had the same idea as you. Go to [Issues](https://github.com/Kong/docs.konghq.com/issues) and read through the titles to see if something sounds similar to what you want to contribute or fix. 

If you find an Issue that aligns with what you want to contribute, go ahead and add a comment stating that you're going to be working on this task. We don't assign Issues. Then, head to [Make your contribution](#make-your-contribution). 

If you don't find an Issue that aligns with what you want to contribute, there's no need to open one up. Instead, go to [Make your contribution](#make-your-contribution). 

### I need ideas on what to contribute

Go to [Issues](https://github.com/Kong/docs.konghq.com/issues) and read through the titles to see if something catches your eye. If you don't find anything of your interest there, explore the following:

* Find a product or area of interest in our current docs.
* Audit a page and determine if it aligns with our [Style Guide](/contributing/style-guide/).

### Make your contribution

Once you've identified what you want to work on, let's get to writing! 

1. Create a branch off `main` in your cloned local project. 

    `git checkout -b {CONCISE_AND_RELEVANT_BRANCH_NAME}`

2. Locate the file(s) you want to modify and make your edits.

3. Add, commit, and push your work to your remote (`{CONCISE_AND_RELEVANT_BRANCH_NAME}`) branch. 

    a. `git add .` to add all work, or `git add {FILE_NAME}` to add a single file

    b. `git commit -m "{DETAILED_COMMIT_MESSAGE}"`

    c. `git push origin {CONCISE_AND_RELEVANT_BRANCH_NAME}`

4. Navigate to GitHub and you should see a message that prompts you to open a PR (Pull Request). If you cannot locate this message, read the terminal output after you have pushed your code, and you should see a link in there to open a PR. 

5. Fill out the PR with a title (initially populated by your commit message), and all form details. The more thorough and clear you are, the easier it is for us to understand the change and why it's been made. 

6. Submit your PR!

We encourage you to explore the [README](https://github.com/Kong/docs.konghq.com/blob/main/README.md) more, read through our [contributing guidelines](/contributing/), and also try out setting up your project locally (via instructions in our README). We appreciate your interest and involvement and are looking forward to seeing your future contributions!
