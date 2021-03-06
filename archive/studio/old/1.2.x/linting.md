---
title: Linting in Kong Studio
toc: false
---

Linting is enabled by default in Kong Studio. As you type, Kong Studio validates your specification in the background for issues. In the screen below, note the red dot next to line `15` indicating that there is an issue on that particular line:

![Red dot indicating line error](https://doc-assets.konghq.com/studio/1.2/red-dot.png)

The *Linter Panel* displays at the bottom of the Editor contents. This panel aggregates all errors and warnings from the specification into a centralized location so it’s easier to get an overall sense of what’s going wrong without scrolling through and checking each individual line. Let’s open up the details panel and see what’s going wrong on line `15`:

![Linter panel message](https://doc-assets.konghq.com/studio/1.2/linter-panel.png)

The message indicates to us that the linter has found an issue due to the parent on line `14`, stating that children keys should be strings instead of numbers. That means the `200` on line `15` should be wrapped inside quotes as `'200'`. Note in the screen below that once we add the quotes, the issue is resolved and the linting error disappears:

![Error free editor](https://doc-assets.konghq.com/studio/1.2/error-free.png)
