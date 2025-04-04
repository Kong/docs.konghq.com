---
title: decK Binary
---

decK is distributed as a Go binary for Windows, MacOS, and Linux. Releases are published to [GitHub Releases](https://github.com/Kong/deck/releases).

## Installation

### Windows

To install decK on Windows, download the release artifact ending with `_windows_amd64.tar.gz` and extract it. Next, run `./deck.exe` from your terminal.

### MacOS

Kong provides a [Homebrew](https://brew.sh) tap for decK. To install decK on MacOS, run:

```bash
brew install kong/deck/deck
```

### Linux

Download the `.deb` or `.rpm` file from the releases page and install it using your package manager.

## Upgrade deck

To upgrade deck, follow the instructions above again for the new version. This will upgrade your installed version.

## Tools

### Mise

If you are using [mise](https://mise.jdx.dev/) to manage your tools, you can use it to manage decK too:

```bash
mise x deck@latest -- deck version
```