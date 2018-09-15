> You are reviewing the contributing guidelines of docs.konghq.com. If you want to
> contribute to Kong itself, then please go
> [here](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md).

# Contributing to docs.konghq.com 📜 🦍

Hello, and welcome! Whether you are looking for help, trying to report a bug,
thinking about getting involved in the project or about to submit a patch, this
document is for you!

Consult the Table of Contents below, and jump to the desired section.


## Table of Contents

- [Where to seek help?](#where-to-seek-help)
- [Where to report bugs?](#where-to-report-bugs)
- [Contributing to Kong documentation and the Kong Catalog](#contributing-to-kong-documentation-and-the-kong-catalog)
  - [Submitting a patch](#submitting-a-patch)
  - [Kong Catalog contributions](#kong-catalog-contributions)
  - [Writing plugin documentation](#writing-plugin-documentation)
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

If the bug is about the https://docs.konghq.com website itself, please report it
in this [repository's issues
tracker](https://github.com/kong/docs.konghq.com/issues/new).

If the bug is related to Kong itself, please refer to the [Kong Contributing
Guideline](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#where-to-report-bugs)
instead.

[Back to TOC](#table-of-contents)


## Contributing to Kong documentation and the Kong Catalog

Improving the documentation is a most welcome form of contribution to the Kong
community! You are encouraged to suggest edits, improvements, or fix any typo
you may find on this website. Please read the below section about
[submitting a patch](#submitting-a-patch).

Adding and improving listings in the Kong Catalog is also encouraged! Please
read the below section
about [Kong Catalog contributions](#kong-catalog-contributions)

If you wish to contribute to Kong itself (as opposed to the documentation
website), then please consult the [Kong Contributing
Guideline](https://github.com/Kong/kong/blob/master/CONTRIBUTING.md#contributing)
instead.

When contributing, be aware of a few things:

- Documention for Kong Catalog listings, which includes all Kong Inc.-published
  and community-published plugins and integrations, lives in the `app/_catalog`
  and `app/_data/extensions` directories. **Versioning is optional, and thus
  potentially inconsistent, for this part of the documentation**.
- Kong documentation lives in `app/x.x.x` and Kong Enterprise documentation
  lives in `app/enterprise/`. **These parts of the documentation are versioned**.
  When proposing a change in these parts of the documentation, consider proposing
  the change for older versions as well.
  Example: if you fix a typo in `app/docs/0.10.x/configuration.md`, this typo
  may also be present in `app/docs/0.9.x/configuration.md`.

[Back to TOC](#table-of-contents)


### Submitting a patch

Feel free to contribute fixes or minor features, we love to receive Pull
Requests! If you are planning to develop a larger feature, come talk to us
first in [Kong Nation](https://discuss.konghq.com/).

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
contributor of docs.konghq.com and member of the Kong community.

Your changes will be deployed as soon as a maintainer gets a chance to trigger
a build, which should generally happen right after your patch was merged.

[Back to TOC](#table-of-contents)


### Kong Catalog contributions

If you are planning on producing a new Kong plugin or integration, with the
intent to list it in the Kong Catalog, you are encouraged to have a quick
call with Kong's Director of Ecosystem, Cooper Marcus -
[book a time](http://meetme.so/cooper), or email him at cooper@konghq.com.

Adding a new listing to the Kong Catalog may be proposed by:

1. Clone this repo
1. Create a publisher directory at`_app/_catalog/`, such as
 `_app/_catalog/your-github-handle` (if you are contributing as an individual)
 or `_app/_catalog/company-name` (if you are contributing as a company). See
 other Kong Catalog listings for examples of publisher names.
1. Create a subdirectory for your extension within your publisher directory -
such as `_app/_catalog/your-name/your-extension`.
1. Copy the `/app/_catalog/_init/my-extension/index.md` file into your extension's
subdirectory. If you are publishing a single version of your extension, which is typical to
start with, then the file name `index.md` should remain.
1. Edit your `index.md` file based on the guidance in comments in that file -
you'll find lots of helpful examples in other extension's files. If you are
documenting a Kong plugin, be sure to see the next section.
1. If you have a custom logo, add a square-format PNG file to
`/app/_assets/images/icons/catalog/` - the filename of your image should be
`publisher_extension` using the "publisher" and "extension" name from step 2.
Custom logos are optional.
1. Be sure to run the docs site locally per the instructions in
the README - you should find your Catalog contribution listed at
`localhost:3000/catalog`
1. Once you are happy with your listing, make a Pull Request to add it to
the Kong Catalog. [Having trouble, or have questions?](#where-to-seek-help)

Kong staff will review your PR, suggest improvements and adjustments as
necessary, and once approved, will merge and deploy your Kong Catalog addition!

[Back to TOC](#table-of-contents)

### Writing plugin documentation

Plugins are documented as extensions under `app/_catalog/` - please look at
the existing plugins for examples, and see additional advice in
`app/_catalog/_init/my-extension/index.md`.

* `description` - text to be added in the Description section. Use YAML's
  [pipe notation](https://stackoverflow.com/questions/15540635/what-is-the-use-of-pipe-symbol-in-yaml)
  to write multi-paragraph text. Note that due to the order that data
  is generated, you may not use forward-references in links (e.g. use
  `[example](http://example.com)` and not `[example][example]` pointing to
  an index at the end).
* `desc` (string, required) - a short, one-line description of the extension.
* `type` (array, required) - what kind of extension this is: `plugin` or
`integration` are supported at this time, though more types will be considered.
* `params`
  * `name` - name of the plugin as it is referred to in Kong's config and Kong's
  Admin API (not always the same spelling as the page name)
  * `api_id` - boolean - whether this plugin can be applied to an API.
  Affects generation of examples and config table.
  * `route_id` - boolean - whether this plugin can be applied to a Route.
  Affects generation of examples and config table.
  * `service_id` - boolean - whether this plugin can be applied to a Service.
  Affects generation of examples and config table.
  * `consumer_id` - boolean - whether this plugin can be applied to a Consumer.
  Affects generation of examples and config table.
  * `config` - the configuration table.
  Each entry is a configuration item with the following fields:
    * `name` - the field name as read by Kong
    * `required` - `true` if required, `false` if optional, `semi`
    if semi-required (required depending on other fields)
    * `default` - the default value. If using Markdown
    (e.g. to make values appear type-written), wrap it in double-quotes like
    ``"`foobar`"``
    * `value_in_examples` - if the field is to appear in examples, this is
    the value to use. A required field with no `value_in_examples` entry
    will resort to the one in `default`.
    * `description` - description of the field.
    Use YAML's pipe notation if writing longer Markdown text.

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

- **docs**: Changes made to any static content files associated with Kong, Kong
  Enterprise, and Kong Catalog documentation (including typo fixes),
  the README.md or this file
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

- **`<ce or ee>/<section>`**: A change that affects Kong docs or Kong
  Enterprise docs and specifies which section.
- **`admin`**: Changes related to the Admin API documentation
- **`proxy`**: Changes related to the proxy documentation
- **`conf`**: Changes related to the configuration file documentation (new
  values, improvements...)
- **`<plugin-or-extension-name>`**: A change to any of the listings in the
  Kong Catalog. This could be `basic-auth`, or `ldap` for example
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

Binary files like images and videos should not be included in your pull request,
with the exception of custom icons for the Kong Catalog -
any request including them will be rejected.

Instead, please:

1. Include the HTML necessary to display your binary file in your code
1. In place of the link to the binary file, use `FIXME`
1. Email your binary files to support@konghq.com, and include a link to your pull request
1. Kong staff will host your binary files on our CDN, and will replace the `FIXME`s in your code
with URLs of the binaries

[Back to TOC](#table-of-contents)
