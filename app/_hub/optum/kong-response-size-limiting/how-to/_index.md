### Caveat
This plugin currently accomplishes response limiting by validating the Content-Length header on upstream responses.
If the upstream lacks the response header, then this plugin will allow the response to pass.

### Installation
Recommended:

```bash
$ luarocks install kong-response-size-limiting
```

Other:

```bash
$ git clone https://github.com/Optum/kong-response-size-limiting.git /path/to/kong/plugins/kong-response-size-limiting
$ cd /path/to/kong/plugins/kong-response-size-limiting
$ luarocks make *.rockspec
```

### Maintainers
[jeremyjpj0916](https://github.com/jeremyjpj0916){:target="_blank"}{:rel="noopener noreferrer"}  
[rsbrisci](https://github.com/rsbrisci){:target="_blank"}{:rel="noopener noreferrer"}

Feel free to [open issues](https://github.com/Optum/kong-response-size-limiting/issues){:target="_blank"}{:rel="noopener noreferrer"}, or refer to our [Contribution Guidelines](https://github.com/Optum/kong-response-size-limiting/blob/master/CONTRIBUTING.md){:target="_blank"}{:rel="noopener noreferrer"} if you have any questions.
