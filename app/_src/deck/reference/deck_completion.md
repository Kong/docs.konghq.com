---
title: deck completion
source_url: https://github.com/Kong/deck/tree/main/cmd/completion.go
content_type: reference
---

Generate completion script.

## Examples

{% navtabs %}
{% navtab Bash %}

```sh
source <(deck completion bash)
```

To load completions for each session, execute once:
{% navtabs %}
{% navtab linux %}
**Linux:**
```sh
deck completion bash > /etc/bash_completion.d/deck
```
{% endnavtab %}
{% navtab  macOS %}
**macOS:**
```sh
deck completion bash > /usr/local/etc/bash_completion.d/deck
```
{% endnavtab %}
{% endnavtabs %}

{% endnavtab %}
{% navtab Zsh%}

If shell completion is not already enabled in your environment,
you will need to enable it. You can execute the following once:
```sh
echo "autoload -U compinit; compinit" >> ~/.zshrc
```

To load completions for each session, execute once:
```sh
deck completion zsh > "${fpath[1]}/_yourprogram"
```

You will need to start a new shell for this setup to take effect.

{% endnavtab %}
{% navtab fish %}

```sh
deck completion fish | source
```

To load completions for each session, execute once:
```sh
deck completion fish > ~/.config/fish/completions/deck.fish
```

{% endnavtab %}
{% navtab Powershell %}

```powershell
PS> deck completion powershell | Out-String | Invoke-Expression
```

To load completions for every new session, run:
```powershell
PS> deck completion powershell > deck.ps1
```

Then source this file from your PowerShell profile.
{% endnavtab %}
{% endnavtabs %}

## Syntax

```
deck completion [command-specific flags] [global flags]
```

## Flags

`-h`, `--help`
:  help for completion 


## Global flags

{% include_cached /md/deck-global-flags.md kong_version=page.kong_version %}

## See also

* [deck](/deck/{{page.kong_version}}/reference/deck/)	 - Administer your Kong clusters declaratively
