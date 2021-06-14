---
repository: "https://github.com/turbot/steampipe-mod-alicloud-compliance"
---

# Alibaba Cloud Compliance Mod

Run individual configuration, compliance and security controls or full compliance benchmarks for `CIS` and across all your Alibaba Cloud accounts.

## References

[Alibaba Cloud](https://alibabacloud.com) provides on-demand cloud computing platforms and APIs to authenticated customers on a metered pay-as-you-go basis.

[CIS Alibaba Cloud Benchmarks](https://www.cisecurity.org/benchmark/alibaba_cloud/) provide a predefined set of compliance and security best-practice checks for Alibaba Cloud accounts.

[Steampipe](https://steampipe.io) is an open source CLI to instantly query cloud APIs using SQL.

[Steampipe Mods](https://steampipe.io/docs/reference/mod-resources#mod) are collections of `named queries`, and codified `controls` that can be used to test current configuration of your cloud resources against a desired configuration.

## Documentation

- **[Benchmarks and controls →](https://hub.steampipe.io/mods/turbot/alicloud_compliance/controls)**
- **[Named queries →](https://hub.steampipe.io/mods/turbot/alicloud_compliance/queries)**

## Get started

Install the Alibaba Cloud plugin with [Steampipe](https://steampipe.io):
```shell
steampipe plugin install alicloud
```

Clone:
```sh
git clone git@github.com:turbot/steampipe-mod-alicloud-compliance
cd steampipe-mod-alicloud-compliance
```

Run all benchmarks:
```shell
steampipe check all
```

Run a single benchmark:
```shell
steampipe check benchmark.cis_v100
```

Run a specific control:
```shell
steampipe check control.cis_v100_2_2
```

### Credentials

This mod uses the credentials configured in the [Steampipe Alibaba Cloud plugin](https://hub.steampipe.io/plugins/turbot/alicloud).

### Configuration

No extra configuration is required.

## Get involved

* Contribute: [GitHub Repo](https://github.com/turbot/steampipe-mod-alicloud-compliance)
* Community: [Slack Channel](https://join.slack.com/t/steampipe/shared_invite/zt-oij778tv-lYyRTWOTMQYBVAbtPSWs3g)
