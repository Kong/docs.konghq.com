> You are reviewing the contributing guidelines of getkong.org. If you want to
> contribute to Kong itself, then please go
> [here](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md).

# Contributing to getkong.org 📜 🦍

Hello, and welcome! Whether you are looking for help, trying to report a bug,
thinking about getting involved in the project or about to submit a patch, this
document is for you!

Consult the Table of Contents below, and jump to the desired section.


## Table of Contents

- [Where to seek help?](#where-to-seek-help)
- [Where to report bugs?](#where-to-report-bugs)
- [Contributing to the documentation](#contributing-to-the-documentation)
  - [Submitting a patch](#submitting-a-patch)
    - [Git branches](#git-branches)
    - [Commit atomicity](#commit-atomicity)
    - [Commit message format](#commit-message-format)
    - [Linting](#linting)
  - [Contributing images, videos, etc](#contributing-images-videos-etc)


## Where to seek help?

Consult the [Kong Contributing
Guideline](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#where-to-seek-for-help)
for an overview of the communication channels at your disposal.

[Back to TOC](#table-of-contents)


## Where to report bugs?

If the bug is about the https://getkong.org website itself, please report it
in this [repository's issues
tracker](https://github.com/kong/getkong.org/issues/new).

If the bug is related to Kong itself, please refer to the [Kong Contributing
Guideline](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#where-to-report-bugs)
instead.

[Back to TOC](#table-of-contents)


## Contributing to the documentation

Improving the documentation is a most welcome form of contribution to the Kong
community! You are encouraged to suggest edits, improvements, or fix any typo
you may find on this website. Please read the below section about
[submitting a patch](#submitting-a-patch).

If you wish to contribute to Kong itself (as opposed to the documentation
website), then please consult the [Kong Contributing
Guideline](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#contributing)
instead.

When contributing, be aware of a few things:

- The plugins documentation lives in the `app/plugins` directory. **This part
  of the documentation is not versioned**, which means that the plugins
  documentation is always reflecting the state of their latest release. This is
  something we will be improving in the future.
- The core documentation lives in `app/docs/x.x.x`. **This part is versioned**.
  When proposing a change in this part of the documentation, consider proposing
  it for older versions as well.
  Example: if you fix a typo in `app/docs/0.10.x/configuration.md`, this typo
  may also be present in `app/docs/0.9.x/configuration.md`.
- There are enterprise edition documents that live under
  `app/enterprise/x.x-x` and have a plugins section specific to EE which
  are versioned unlike CE plugins.

[Back to TOC](#table-of-contents)


### Submitting a patch

Feel free to contribute fixes or minor features, we love to receive Pull
Requests! If you are planning to develop a larger feature, come talk to us
first!

When contributing, please follow the guidelines provided in this document. They
will cover topics such as the commit message format to use or how to run the
linter.

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
contributor of getkong.org and member of the Kong community.

Your changes will be deployed as soon as a maintainer gets a chance to trigger
a build, which should generally happen right after your patch was merged.

[Back to TOC](#table-of-contents)


#### Git branches

In this repository, `master` represents the current state of the website, and
should constantly be deployed. Branch off of this branch for local development.

If you have write access to the GitHub repository, please follow the following
naming scheme when pushing your branch(es):

- `docs/<ce|ee>-foo-bar` for updates to contents of the documentation (Markdown
  files), README.md, or this file
- `feat/foo-bar` for new website features e.g. Ruby, JavaScript, HTML, or CSS
  changes to support a new feature
- `fix/foo-bar` for website bug fixes (**not** including typos and other fixes
  to the documentation itself, see the [Type](#type) section below)

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

- **docs**: Changes made to any static content files associated with Kong CE
  or EE documentation (including typo fixes), the README.md or this file
- **feat**: A new website feature e.g. Ruby, JavaScript, HTML, or CSS changes
  to support a new feature
- **fix**: A website bug fix (related to the Ruby, JavaScript, HTML, or CSS
  assets). Typos and other fixes to the _contents_ of the documentation
  (markdown files) are not included in this scope
- **style**: CSS fixes, formatting, missing semi colons, :nail_care:
- **refactor**: A code change that neither fixes a bug nor adds a feature, and
  is too big to be considered `chore`
- **chore**: Maintenance changes related to code cleaning that isn't considered
  part of a refactor, build process updates, dependency bumps, or auxiliary
  tools and libraries updates (npm modules, Travis-ci, etc...)


##### Scope

The scope is the part of the codebase that is affected by your change. Choosing
it is at your discretion, but here are some of the most frequent ones:

- **`<ce or ee>/<section>`**: A change that affects the community edition or
  enterprise edition docs and specifies which section.
- **`admin`**: Changes related to the Admin API documentation
- **`proxy`**: Changes related to the proxy documentation
- **`conf`**: Changes related to the configuration file documentation (new
  values, improvements...)
- **`<plugin-name>`**: This could be `basic-auth`, or `ldap` for example
- **`*`**: When the change affects too many parts of the codebase at once (this
  should be rare and avoided)


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

As mentioned in the guidelines, to submit a patch, the linter must succeed. You
can run the linter like so:

```
$ npm run test
```

### Contributing images, videos, etc

Binary files like images and videos should not be included in your pull request - 
any request including them will be rejected. 

Instead, please:

1. Include the HTML necessary to display your binary file in your code
1. In place of the link to the binary file, use `FIXME`
1. Email your binary files to support@konghq.com, and include a link to your pull request
1. Kong staff will host your binary files on our CDN, and will replace the `FIXME`s in your code
with URLs of the binaries

[Back to TOC](#table-of-contents)
