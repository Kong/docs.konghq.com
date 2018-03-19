> You are reviewing the contributing document for getkong.org. If you want to know how to contribute to Kong itself, then please go [here](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md)

# Contributing to getkong.org 📜 🦍

Hello, and welcome! Whether you are looking for help, trying to report a bug,
thinking about getting involved in the project or about to submit a patch, this
document is for you! Its intent is to be both an entry point for newcomers to
the community (of all technical backgrounds), and a guide/reference for
contributors and maintainers.

Consult the Table of Contents below, and jump to the desired section.

## Table of Contents

- [Where to seek for help?](#where-to-seek-for-help)
  - [Enterprise Edition](#enterprise-edition)
  - [Community Edition](#community-edition)
- [Where to report bugs?](#where-to-report-bugs)
- [Contributing](#contributing)
  - [Improving the documentation](#improving-the-documentation)
  - [Submitting a patch](#submitting-a-patch)
    - [Git branches](#git-branches)
    - [Commit atomicity](#commit-atomicity)
    - [Commit message format](#commit-message-format)
    - [Static linting](#linting)


## Where to seek for help?

### Enterprise Edition

If you are experiencing a P1 issue, please call the [24/7 Enterprise Support
phone line](https://support.konghq.com/hc/en-us/articles/115004921808-Telephone-Support)
for immediate assistance, as published in the Customer Success Reference Guide.

If you are interested in becoming a Kong Enterprise customer, please visit
https://www.konghq.com/enterprise/ or contact us at
[sales@konghq.com](mailto:sales@konghq.com).

[Back to TOC](#table-of-contents)


### Community Edition

There are several channels where you can get answers from the community
or the maintainers of this project:

- Our public forum, [Kong Nation](https://discuss.konghq.com/), for asynchronous
  and lengthy chatter.
- Gitter, for faster, but more ephemeral conversations. The room is
  hosted at https://gitter.im/Mashape/kong
- The IRC channel, registered on freenode as [#kong
  ](https://webchat.freenode.net/?channels=kong)

**Please avoid opening GitHub issues for general questions or help**, as those
should be reserved for actual feature requests and bug reports. The Kong community is welcoming and
more than willing to assist you on those channels!

[Back to TOC](#table-of-contents)


## Where to report bugs?

Feel free to [submit an issue](https://github.com/Kong/kong/issues/new) on
the GitHub repository, we would be grateful to hear about it! Please make sure
to respect the GitHub issue template, and include:

1. A summary of the issue
2. A list of steps to reproduce the issue

If you wish, you are more than welcome to propose a patch to fix the issue!
See the [Submit a patch](#submitting-a-patch) section for more information
on how to best do so.

[Back to TOC](#table-of-contents)


## Contributing

We welcome contributions of all kinds, you do not need to code to be helpful!
All of the following tasks are noble and worthy contributions that you can
make without coding:

- Reporting a bug (see the [report bugs](#where-to-report-bugs) section)
- Helping other members of the community on the support channels
- Fixing a typo in the code
- Fixing a typo in the documentation at https://getkong.org (see
  the [documentation contribution](#improving-the-documentation) section)
- Providing your feedback on the proposed features and designs
- Reviewing Pull Requests

If you wish to contribute code (features or bug fixes), see the [Submitting a
patch](#submitting-a-patch) section.

[Back to TOC](#table-of-contents)


### Improving the documentation

When contributing, be weary of a few things:

- The plugins documentation lives in the `app/plugins` directory. **This part
  of the documentation is not versioned**, which means that the plugins
  documentation is always reflecting the state of their latest release. This is
  something we will be improving in the future.
- The core documentation lives in `app/docs/x.x.x`. **This part is versioned**.
  When proposing a change in this part of the documentation, consider proposing
  it for older versions as well.
  Example: if you fix a typo in `app/docs/0.10.x/configuration.md`, this typo
  may also be present in `app/docs/0.9.x/configuration.md`.
- There are enterprise edition documents that live under `app/docs/enterprise/x.x-x`
  and have a plugins section specific to EE which are versioned unlike CE plugins.

[Back to TOC](#table-of-contents)


### Submitting a patch

Feel free to contribute fixes or minor features, we love to receive Pull
Requests! If you are planning to develop a larger feature, come talk to us
first!

When contributing, please follow the guidelines provided in this document. They
will cover topics such as the commit message format to use or how to run the linter.

Once you have read them, and you are ready to submit your Pull Request, be sure
to verify a few things:

- Your commit history is clean: changes are atomic and the git message format
  was respected
- Rebase your work on top of the base branch (seek help online on how to use
  `git rebase`; this is important to ensure your commit history is clean and
   linear)
- The linting is succeeding: run `npm run test` (see the development
  documentation for additional details)

If the above guidelines are respected, your Pull Request has all its chances
to be considered and will be reviewed by a maintainer.

If you are asked to update your patch by a reviewer, please do so! Remember:
**you are responsible for pushing your patch forward**. If you contributed it,
you are probably the one in need of it. You must be prepared to apply changes
to it if necessary.

If your Pull Request was accepted, congratulations! You are now an official
contributor of getkong.org. Your changes will be included in the subsequent release.
Deploys are currently manually pushed via github pages, so please allow for some
time for the changes to be persisted to the site.

[Back to TOC](#table-of-contents)

#### Git branches

Everything on `master` will get merged and pushed to github pages. Branch off of
this branch for local development.

If you have write access to the GitHub repository, please follow the following
naming scheme when pushing your branch(es):

- `feat/foo-bar` for new features
- `fix/foo-bar` for bug fixes
- `tests/foo-bar` when the change concerns only the test suite
- `refactor/foo-bar` when refactoring code without any behavior change
- `style/foo-bar` when addressing some style issue
- `docs/foo-bar` for updates to the README.md, docs, etc.

[Back to TOC](#table-of-contents)

#### Commit atomicity

When submitting patches, it is important that you organize your commits in
logical units of work. You are free to propose a patch with one or many
commits, as long as their atomicity is respected. This means that no unrelated
changes should be included in a commit.

For example: you are writing a patch to fix a bug, but in your endeavour, you
spot another bug. **Do not fix both bugs in the same commit!**. Finish your
work on the initial bug, propose your patch, and come back to the second bug
later on. This is also valid for unrelated style fixes, refactorings, etc...

You should use your best judgement when facing such decisions. A good approach
for this is to put yourself in the shoes of the person who will review your
patch: will they understand your changes and reasoning just by reading your
commit history? Will they find unrelated changes in a particular commit? They
shouldn't!

Writing meaningful commit messages that follow our commit message format will
also help you respect this mantra (see the below section).

[Back to TOC](#table-of-contents)


#### Commit message format

To maintain a healthy Git history, we ask of you that you write your commit
messages as follows:

- The tense of your message must be **present**
- Your message must be prefixed by a type, and a scope
- The header of your message should not be longer than 50 characters
- A blank line should be included between the header and the body
- The body of your message should not contain lines longer than 72 characters

Here is a template of what your commit message should look like:

```
<type>(<scope>) <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```


##### Type

The type of your commit indicates what type of change this commit is about. The
accepted types are:

- **docs**: Changes to the README.md, this file, or static content files associated
  with Kong CE or EE documentation.
- **feat**: A new feature
- **fix**: A bug fix
- **hotfix**: An urgent bug fix during a release process
- **style**: CSS fixes, formatting, missing semi colons, 💅
- **refactor**: A code change that neither fixes a bug nor adds a feature, and
  is too big to be considered just `perf`
- **chore**: Maintenance changes related to code cleaning that isn't
  considered part of a refactor, build process updates, dependency bumps, or
  auxiliary tools and libraries updates (npm modules, Travis-ci, etc...).


##### Scope

The scope is the part of the codebase that is affected by your change. Choosing
it is at your discretion, but here are some of the most frequent ones:

- **`<ce or ee>/<section>`**: A change that affects the community edition or enterprise
  edition docs and specifies which section.
- **conf**: Configuration-related changes (new values, improvements...)
- **`<plugin-name>`**: This could be `basic-auth`, or `ldap` for example
- `*`: When the change affects too many parts of the codebase at once (this
  should be rare and avoided)


##### Subject

Your subject should contain a succinct description of the change. It should be
written so that:

- It uses the present, imperative tense: "fix typo", and not "fixed" or "fixes"
- It is **not** capitalized: "fix typo", and not "Fix typo"
- It does **not** include a period. :smile:


##### Body

The body of your commit message should contain a detailed description of your
changes. Ideally, if the change is significant, you should explain its
motivation, the chosen implementation, and justify it.

As previously mentioned, lines in the commit messages should not exceed 72
characters.


##### Footer

The footer is the ideal place to link to related material about the change:
related GitHub issues, Pull Requests, fixed bug reports, etc...


##### Examples

Here are a few examples of good commit messages to take inspiration from:

```
docs(ee/dev-portal) cleanup installation instructions

* add ports exposed for Dev Portal functionality
* use relative links and version them when necessary

From #623
```

[Back to TOC](#table-of-contents)


#### Linting

As mentioned in the guidelines, to submit a patch, the linter must succeed. You can run the linter like so:

```
$ npm run test
```

[Back to TOC](#table-of-contents)
