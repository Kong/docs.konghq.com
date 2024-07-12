## Troubleshooting the local build

### Invalid byte sequence in US-ASCII

If you encounter an error that looks like this:

```
app/_plugins/generators/utils/frontmatter_parser.rb:8:in `match': invalid byte sequence in US-ASCII (ArgumentError)

      @result = @string.match(Jekyll::Document::YAML_FRONT_MATTER_REGEXP)
                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
    from app/_plugins/generators/utils/frontmatter_parser.rb:8:in `match'
```

You can try setting the `LANG` or `LC_ALL` environment variable to `en_US.UTF-8`. For example:

```bash
export LANG=en_US.UTF-8
```


## Skipping slow generators

Disable the `Hub` generator for faster builds by setting the `DISABLE_HUB` environment variable:


```bash
DISABLE_HUB=1 make run
```
The `Sitemap` generator is disabled by default if `JEKYLL_ENV=development`, so it doesn't run locally.
Disabling the `Hub` generator can be done by setting the environment variable: `DISABLE_HUB`.
