# Backporting Tools

These tools are not officially supported. They were built as a proof of concept and shared in case they're useful to others.

They allow you to backport uncommitted changes to old versions.

Here's how you'd backport changes made in `deck/1.11.x/index.md` to all versions since (and including) `1.9.x`:

```bash
node run.js --oldest 1.9.x --source ../app/deck/1.11.x/index.md
```

You need to use `run.js` once per edited file. Run `git diff` to get the name of the file to pass in.

To backport multiple changes in a single command, you can use a loop:

```bash
OLDEST=2.6.x FILES=../app/gateway; \
for i in $(git diff --name-only $FILES); do node run.js --oldest $OLDEST --source $i; done
```
