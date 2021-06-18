# Alibaba Cloud Compliance Scanning Tool

50+ checks covering industry defined security best practices across all Alibaba Cloud regions.

**Includes full support for v1.0.0 CIS benchmarks:**

![image](https://github.com/turbot/steampipe-mod-alicloud-compliance/blob/main/docs/alicloud_cis_v100_console.png?raw=true)

Includes support for:
* [Alibaba Cloud CIS v1.0.0](https://hub.steampipe.io/mods/turbot/alicloud_compliance/controls/benchmark.cis_v100)

## Quick start

1) Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```shell
brew tap turbot/tap
brew install steampipe

steampipe -v
steampipe version 0.5.3
```

2) Install the Alibaba Cloud plugin
```shell
steampipe plugin install alicloud
```

3) Clone this repo
```sh
git clone git@github.com:turbot/steampipe-mod-alicloud-compliance
cd steampipe-mod-alicloud-compliance
```

4) Run all benchmarks:
```shell
steampipe check all
```

### Other things to checkout

Run an individual benchmark:
```shell
steampipe check benchmark.cis_v100
```

Use Steampipe introspection to view all current controls:
```
steampipe query "select resource_name from steampipe_control;"
```

Run a specific control:
```shell
steampipe check control.cis_v100_2_1
```

## Contributing

If you have an idea for additional compliance controls, or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing. (Even if you just want to help with the docs.)

- **[Join our Slack community →](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)** and hang out with other Mod developers.
- **[Mod developer guide →](https://steampipe.io/docs/steampipe-mods/writing-mods.md)**

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-alicloud-compliance/blob/main/LICENSE).

`help wanted` issues:
- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Alibaba Cloud Compliance Mod](https://github.com/turbot/steampipe-mod-alicloud-compliance/labels/help%20wanted)
