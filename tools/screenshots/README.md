## Prerequisites

Make sure python3 and pipenv are installed:

1. Install `python3`:

    ```
    brew install python3
    ```

2. Install `pipenv`:

    ```
    python3 -m pip install pipenv
    ```

## Setup

We're using a fork of `shot-scraper` in order to store reusable macros in an external file.
This has been [submitted as a PR](https://github.com/simonw/shot-scraper/pull/111) but not yet merged.

This means that you'll need to install from the fork to generate screenshots:

```
git clone https://github.com/mheap/shot-scraper -b macros-support
cd shot-scraper
python3 -m pipenv shell
pip install .
```

You'll need to run `python3 -m pipenv shell` any time you want to use the tool.

## Authentication

Konnect requires authentication before it will show you the pages you need. 
Run the following command, then press `<enter>` once you see the Konnect dashboard.

> If you want to use a personal org, switch the Okta URL for https://cloud.konghq.com/login. 
> You'll also need to update the URLs in each screenshot configuration e.g. different runtime
> group IDs.

```bash
shot-scraper auth https://konghq.okta.com/app/UserHome /tmp/auth.json
```

## Usage

Running the following command to regenerate screenshots:

```bash
cd /path/to/docs
cd tools/screenshots
shot-scraper multi  -a /tmp/auth.json --macro macros.yaml MY_SCREENSHOTS_FILE.yaml
```

## Debugging

When building new screenshots, it's helpful to see the browser. This is not currently an 
available `shot-scraper` option, so run the following command to patch it to show the browser:

```bash
export F=`which shot-scraper | sed 's#bin/shot-scraper#/lib/python3.10/site-packages/shot_scraper/cli.py#'`
cat <<< "$(awk 'NR==335{print "    browser_kwargs[\"headless\"] = False"}1' $F | less)" > $F
```