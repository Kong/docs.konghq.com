# Vale

## Overview

We are using [Vale](https://docs.errata.ai/vale/about) to lint our documentation. Vale is a natural language linter that enforces a set of rules that the documentation team has created and returns errors in cases where those rules are broken. Vale is part of the suite of Github actions that test and validate every PR that is pushed to the documentation repo. Vale can and should be run locally to quickly test your documentation before submitting it. 

<!-- vale off -->
```
Docs
│.github
│ ├── styles
│ │   └── kong
│ │       ├── Spelling.yml
│ │       ├── Terms.yml
│ │       └── dictionary.txt
│ └── workflows
│     └── linting.yml
└── .vale.ini
```

<!-- vale on -->
- `.vale.ini`: This is the main configuration file for Vale. For information on how this file works, [the official documentation](https://docs.errata.ai/vale/config) contains detailed information about this file.
- `spelling.yml`: This file contains the rules for enforcing spelling. It inherits `dictionary.txt` and sets the `level` value to `error`. This setting will cause a build to fail.
- `dictionary.txt`: This file is where you can add words that should be ignored by the dictionary. This file is case **in-sensitive**, and ordered alphabetically in ascending order.
- `Terms.yml`: This file is used for specific cases where the word may be spelled correctly, but incorrectly capitalized in the case of a company or product name.
- `linting.yml`: This file contains the GHA workflow.

The `.vale.ini` configuration file considers anything within the `.github/styles/kong` as part of the `Kong` style. Any new rule written within the Kong style directory will be automatically accessible to Vale. 
At this time we only use Vale to enforce: 
* spelling

## Installing Locally

To install Vale locally on Linux or OSX run:  

`brew install vale` 

For windows: 

`choco install vale`

Once vale is installed, you can use it locally within any repo that contains a `.vale.ini` file. Locally, Vale can be run against both files and directories. The syntax for both cases is: `vale PATH_TO_FILE_OR_DIRECTORY`. 


### Spelling

Spelling rules are enforced by the file `dictionary.txt` and `Spelling.yml` working in conjunction with a pre-installed American-English [dictionary](https://github.com/errata-ai/en_US-web). `dictionary.txt` is case sensitive, and is ordered alphabetically in ascending order. 


Locally errors are written to standard output and look like this: 


```bash
FILE.md
 6128:70   error  Did you really mean 'boolean'?  kong.Spelling
 ✖ 1 errors, 0 warnings and 0 suggestions in 1 files.
```

The first line is the filename and location, the next line references the location of the error in the format (Line number: Character). The output highlights the word that triggered the error. `kong.spelling` references the name of the configuration file where this rule is written. The last line is a summary of the output.

Spelling is managed by `dictionary.txt`, in the case you receive a false-positive for words that are spelled correctly but are triggering an error, adding the word to the `dictionary.txt` file will force Vale to ignore that word. 

 
### Terms 

The terms file can be used for any type of substitution. It would be bad practice to use the `terms.yml` file to write substitutions for anything other than terms, so if you want to write new rules, create a new yaml file for them. 

This is a sample Terms file that shows you three types of term substitution. The first requires quotation marks so that Vale does not consider the brackets an attempt at writing a regular expression. The second uses a regular expression to catch both lowercase and uppercase instances of the term `Developer Portal`. The final one, is a standard substitution that catches lowercase instances of the word Kong, throws an error and suggests the uppercase alternative. 

<!-- vale off -->
```bash
extends: substitution
message: Use '%s' instead of '%s'.
level: error
ignorecase: true
swap:
  konnect: "{{site.konnect_short_name}}"
  Developer [Pp]ortal: Dev Portal
  '(?:kubernetes|k8s)': Kubernetes
  kong: Kong
```

Proper nouns that must be capitalized, or written in a specific way can be handled using a combination of `dictionary.txt` and `terms.yml`. In the case of a word like "k8s", where you want to suggest every instance of k8s be changed to "Kubernetes" in `terms.yml` create a rule like this: 

```yaml
extends: substitution
message: Use '%s' instead of '%s'.
level: error
ignorecase: true
swap:
  k8s: Kubernetes

```

These rules catch the following cases: 

```bash
14:1    error  Use 'Kubernetes' instead of     kong.Terms
                'k8s'.
15:1    error  Did you really mean             kong.Spelling
                'kubernetes'?
```

You can also use regex syntax to create rules: 

```yaml
extends: substitution
message: Use '%s' instead of '%s'.
level: error
ignorecase: true
swap:
  '(?:kubernetes|k8s)': Kubernetes

```

So a file that contains `kubernetes` or `k8s` will return: 

```bash
 README.md
 3:1  error  Use 'Kubernetes' instead of     kong.Terms
             'k8s'.
 5:1  error  Did you really mean             kong.Spelling
             'kubernetes'?
 5:1  error  Use 'Kubernetes' instead of     kong.Terms
             'kubernetes'.
```

This prompts the users to replace `k8s` and `kubernetes` with "Kubernetes"

<!-- vale on -->

### Scope

Vale ignores most standard Github flavored markdown syntax. In our docs site we use various non-Github flavored markdown syntax to invoke plugins and their functions. The only way to handle these cases is to write regular expression representations of the syntax to the `.vale.ini` configuration file. For more information about scoping within the Vale read the [official documentation](https://docs.errata.ai/vale/scoping). 

In our configuration file we use both `BlockIgnores` and `TokenIgnores`. 

Currently we use the following rules: 

```yml
BlockIgnores = (?s) *(\[(.*?)\])(\((.*?)\)), \
(\x60\x60\x60[a-z]*[\s\S]*?\n\x60\x60\x60), \
(\((http.*://|\.\/|\/).*?\))

TokenIgnores = {%.*?%}, \
{{.*?}}
```

* `(?s) *(\[(.*?)\])(\((.*?)\))`: ignores the url pattern and everything inside of it `[example](example)`
* `(\x60\x60\x60[a-z]*[\s\S]*?\n\x60\x60\x60)`: ignores our inline file syntax that starts with three back-ticks, and ends with three back-ticks. 
* `(\((http.*://|\.\/|\/).*?\))`: ignores http(s) urls that are used within code blocks or as part of urls that are in some of the automatically generated docs. 
* `{%.*?%}`: This rule ignores every instance of `{% example %}` and the text **inside** of the brackets. 
*  `{{.*?}}`: Ignores instances where we use `{{ example }}` and the pattern **inside** of the brackets. 


## Ignoring text 

Vale can be forced to ignore sections of text using the following syntax:

```
<!-- vale off -->
 misslepl wrd k8s k7s kubernetes konglowercase 
<!-- vale on -->
```
Everything in that section will be ignored. Consider using this exclusively for edge-cases where text should be used in a way that does not fit our current rule-set.


## Ignoring raw link text

Because our URLs contain product names, they will trigger terms or dictionary checks. 
If you need to ignore raw link text wrap the link in code tags: 

[`konnect.konghq.com`](https://konnect.konghq.com")


## Policy around adding new rules

The following two rules are in place while we are integrating Vale into our repository. 

* Run **only** on modified files: This rule is set automatically by the Github Actions workflow. Vale will only run on files that were modified in the commit. 
* When adding a new rule, the person adding the rule must ensure that every doc in the `src` directory passes all of the checks including the new rule. The PR containing the rule must also contain the files in the `src` directory, changed to conform to the new check. 

### Installing the Vale VS Code extension

Vale has a [VS Code extension](https://github.com/errata-ai/vale-vscode) that functions as an in-editor linter using the rules that exist within the repository. The extension works with both Vale Server and Vale, the command-line linter. Because you have Vale installed locally, you do not need to install Vale Server unless you want Vale Server specific functionality. 

1. Find the `vale-vscode` extension within the VS code marketplace, and install it.

2. From the Vale settings page, set `vale.core.useCLI` to `true`

3. Restart VS Code. 

Once VS code is restarted, you can navigate to any markdown file and there will be a mark on any word that is in violation of a Vale rule. Hovering over the word will tell you exactly what rule it is breaking, and also provide you a link to file. 
