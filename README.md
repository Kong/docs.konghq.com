# KONG Website

This folder is the source code for [Kong](https://github.com/Mashape/kong)'s website. It is a [Jekyll](http://jekyllrb.com/) website hosted on GitHub pages.

## Requirements

- [npm](https://www.npmjs.com/)
- [Bundler](http://bundler.io/)

## Install

>```bash
gem install bundler
npm install
>```

## Running locally

>```bash
npm start
>```

## Generating Public Lua API from Kong

- Have a local clone of Kong.
- Checkout the desired branch/tag/release.
- Set an env variable `KONG_PATH` to point to your local clone.
- Run: `gulp docs`
- Module docs are generated into `./lua-reference`.
- Manually move to the desired location (appropriate version folder).

## Deploying

This will deploy to GitHub pages:

>```bash
npm run deploy
>```
