{% navtabs %}
{% navtab Using a downloaded RPM package %}

Execute a command similar to the following, using the appropriate RPM filename
for the package you downloaded:

```bash
$ sudo yum install /path/to/package.rpm
```
{% endnavtab %}
{% navtab Using Yum repo %}

1. Move the repo file from your home directory to the `/etc/yum.repos.d/`
directory.

    ```bash
    $ sudo mv config.repo /etc/yum.repos.d/
    ```

2. Run the installation using the Yum repository:

    ```bash
    $ sudo yum update -y
    $ sudo yum install kong-enterprise-edition -y
    ```
{% endnavtab %}
{% endnavtabs %}
