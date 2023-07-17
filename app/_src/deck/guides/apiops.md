---
title: APIOps with decK 
content_type: explanation
---

decK 


list:
- blah 
- blah 

code format `--state`

link [distributed configuration](/deck/{{page.kong_version}}/guides/distributed-configuration/).

code block
```sh
deck dump --select-tag team-svc1 -o svc1.yaml
```

callout
{:.important}
> As a best practice, the way you `sync` configurations should be consistent with the way you
initially `dump`ed them.

