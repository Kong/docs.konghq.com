{:.note}
> You may receive a warning that the GPG key is incorrect when installing Kong Gateway
> To resolve this issue, run `sudo rpm --import {{ site.links.web }}/assets/keys/2023-rpm.asc` then run `yum install` again