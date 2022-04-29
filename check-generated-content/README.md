# check-generated-content

How it works:

* Fetch the PR and check if `changed_files` is > `MAX_CHANGED_FILES` (currently 200)
* If too many files were changed, add the `ci:check-skipped:generated-files` label
* If we can proceed:
  * Fetch all changed files in the PR
  * Filter out entries that were `removed`
  * Filter out entries that do not end in `.md`
  * For each file returned, fetch the content and parse the frontmatter
  * If it contains `source_url`, add it to a list of generated files
  * Add a comment listing all generated files, grouped by `source_url`
  * Add the `ci:prevent-merge:generated-files` label to prevent merging

## Running Locally

The easiest way to test this code is to run it locally. Here's the command you need:

```
GITHUB_SHA=0c025f7f0fbc7c21c75e15c162b2afd0f4b26baf GITHUB_REPOSITORY=kong/docs.konghq.com GITHUB_TOKEN=<your_token> node run.js --pr 3890
```

Replace the `GITHUB_SHA` with the latest commit SHA from your PR, and the `GITHUB_TOKEN` with a valid GitHub API token. Finally, change the `--pr` argument to the PR that you want to test against.