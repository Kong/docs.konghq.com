# Show Version Diff

Show the changes between all versions of a single file using `diff`.

Run the diff script from the `show-version-diff` folder. The following 
command shows all changes to `deck.md`, ignoring the `pre-1.7` folder:

```bash
node run.js --source ../app/deck/1.11.x/reference/deck.md --ignore "pre-1.7"
```
