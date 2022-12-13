To run Kuma on Kubernetes, you need to download the Kuma cli (`kumactl`) on your machine.

{% tabs install_kumactl useUrlFragment=false %}
{% tab install_kumactl Script %}

You can run the following script to automatically detect the operating system and download Kuma:

<div class="language-sh">
  <pre class="no-line-numbers"><code>curl -L https://kuma.io/installer.sh | VERSION={{ page.latest_version }} sh -</code></pre>
</div>

You can omit the `VERSION` variable to install the latest version. 
{% endtab %}
{% tab install_kumactl Direct Link %}

You can also download the distribution manually. Download a distribution for the **client host** from where you will be executing the commands to access Kubernetes:

* <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-centos-amd64.tar.gz">CentOS</a>
* <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-rhel-amd64.tar.gz">RedHat</a>
* <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-debian-amd64.tar.gz">Debian</a>
* <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-ubuntu-amd64.tar.gz">Ubuntu</a>
* <a href="https://download.konghq.com/mesh-alpine/kuma-{{ page.latest_version }}-darwin-amd64.tar.gz">macOS</a> or run `brew install kumactl`

and extract the archive with `tar xvzf kuma-{{ page.latest_version }}.tar.gz`
{% endtab %}
{% endtabs %}

Once downloaded, you will find the contents of Kuma in the `kuma-{{ page.latest_version }}` folder. In this folder, you will find - among other files - the `bin` directory that stores the executables for Kuma, including the CLI client [`kumactl`](/docs/{{ page.version }}/explore/cli).

{% tip %}
**Note**: On Kubernetes - of all the Kuma binaries in the `bin` folder - we only need `kumactl`.
{% endtip %}

So we enter the `bin` folder by executing: `cd kuma-{{ page.latest_version }}/bin`

We suggest adding the `kumactl` executable to your `PATH` (by executing: `PATH=$(pwd):$PATH`) so that it's always available in every working directory. Or - alternatively - you can also create link in `/usr/local/bin/` by executing:

```sh
ln -s kuma-{{ page.latest_version }}/bin/kumactl /usr/local/bin/kumactl
```

