---
title: CLI Reference
---

# CLI Reference

Kong comes with a ***Command Line Interface*** (refered as "CLI") which lets you perform operations such as starting and stopping a node. Each command is run in the context of a single node, since Kong as no cluster awareness yet.

Almost every CLI command needs access to your configuration file in order to be aware of what is your node's NGiNX working directory, (known as the "prefix path" for those familiar with NGiNX), and referenced as `nginx_working_dir` in your Kong configuration file.

**Note:** If you haven't already, we recommand you to read the [configuration guide][configuration].

---

## start

## stop

## quit

## restart

## reload


















[configuration]: /docs/{{page.kong_version}}/configuration
