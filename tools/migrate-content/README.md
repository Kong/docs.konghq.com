# migrate-content

A tool to help move an entire `_src` directory to another location and update all current pages using that folder with a `src` entry.

To use, edit `run.js` and set `pattern` and `prefix`.

This example edits all `kic_2.*` nav files and tells them to look in `app/_src/kic-v2` rather than `app/_src/kubernetes-ingress-controller`:

```javascript
const pattern = "*kic_2.*";
const prefix = "/kic-v2/";
```

Run `node run.js` after editing, then in the root of the docs folder execute the `git mv` command that the script returns.

`make run` should now build the site without any issues, with content from the new `_src` folder.