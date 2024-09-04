---
title: Migrate to the new DNS client
---
This guide walks you through migrating from the old DNS client to the new one. The new DNS client introduces a new standardized way to configure a service, and helps improve performance.

## Migrate the DNS client configuration

### Record types

The new DNS client introduces some changes in the support for different record types. To avoid issues, make sure to check your configuration before migrating.

#### SRV

The new DNS client handles SRV records differently than the previous one. If you enable SRV support with the `resolver_family` directive, the client will only query SRV records if the domain name follows the RFC 2782 format (`_<service>._<proto>.<name>`). If the SRV record query fails, the client will not attempt to query the domain's IP addresses (A and AAAA records) again.

Before enabling SRV support with the new DNS client, make sure that the domain name is registered with your DNS service provider in the supported format.

#### CNAME

The DNS client does not offer CNAME dereferencing, this task is entirely handled by the DNS server.

{:.note}
> The new DNS client does not consider the order of record types when querying a domain. It only queries either IP addresses (A and AAAA records) or SRV records, but not both.

### Custom directives

If you had custom values for the directives under `DNS RESOLVER` in `kong.conf`, you will need to manually add these values to the corresponding directives under `New DNS RESOLVER`.

{% capture same %}Same behavior{% endcapture %}

|Old DNS resolver directive|New DNS resolver directive|Comment|
|---|---|---|
|`dns_resolver`|`resolver_address`|{{same}}|
|`dns_hostsfile`|`resolver_hostsfile`|{{same}}|
|`dns_order`|`resolver_family`|The new directive is only used to define the supported query types, there is no a specific order.|
|`dns_valid_ttl`|`resolver_valid_ttl`|{{same}}|
|`dns_stale_ttl`|`resolver_stale_ttl`|{{same}}|
|`dns_not_found_ttl` and `dns_error_ttl`|`resolver_error_ttl`|The two directives are combined into a single one in the new client.|
|`dns_cache_size`|`resolver_lru_cache_size` and `resolver_mem_cache_size`|The old directive is split into two new ones: `resolver_lru_cache_size` is used to specify the size of the L1 LRU lua VM cache, and `resolver_mem_cache_size` the size of the L2 shared memory cache.|
|`dns_no_sync`|N/A|This directive no longer exists; requests are always synchronized in the new client.|

## Enable the new DNS client

The new DNS client is disabled by default. To enable it:

1. Uncomment the `new_dns_client` directive in your `/etc/kong/kong.conf` file.
1. Set the value to `on`.