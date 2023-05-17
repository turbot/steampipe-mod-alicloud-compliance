# Alibaba Cloud Compliance Mod for Steampipe

50+ checks covering industry defined security best practices across all Alibaba Cloud regions.

Run checks in a dashboard:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-alicloud-compliance/main/docs/alicloud_cis_v100_dashboard.png)

Or in a terminal:
![image](https://raw.githubusercontent.com/turbot/steampipe-mod-alicloud-compliance/main/docs/alicloud_cis_v100_console.png)

Includes support for:
* [Alibaba Cloud CIS v1.0.0](https://hub.steampipe.io/mods/turbot/alicloud_compliance/controls/benchmark.cis_v100)

## Getting started

### Installation

Download and install Steampipe (https://steampipe.io/downloads). Or use Brew:

```sh
brew tap turbot/tap
brew install steampipe
```

Install the Alibaba Cloud plugin with [Steampipe](https://steampipe.io):

```sh
steampipe plugin install alicloud
```

Clone:

```sh
git clone https://github.com/turbot/steampipe-mod-alicloud-compliance.git
cd steampipe-mod-alicloud-compliance
```

### Usage

Before running any benchmarks, it's recommended to generate your AliCloud credential report:

```sh
aliyun ims GenerateCredentialReport --endpoint ims.aliyuncs.com
```

Start your dashboard server to get started:

```sh
steampipe dashboard
```

By default, the dashboard interface will then be launched in a new browser
window at http://localhost:9194. From here, you can run benchmarks by
selecting one or searching for a specific one.

Instead of running benchmarks in a dashboard, you can also run them within your
terminal with the `steampipe check` command:

Run all benchmarks:

```sh
steampipe check all
```

Run a single benchmark:

```sh
steampipe check benchmark.cis_v100
```

Run a specific control:

```sh
steampipe check control.cis_v100_2_1
```

Different output formats are also available, for more information please see
[Output Formats](https://steampipe.io/docs/reference/cli/check#output-formats).

### Credentials

This mod uses the credentials configured in the [Steampipe AliCloud plugin](https://hub.steampipe.io/plugins/turbot/alicloud).

### Configuration

No extra configuration is required.

### Common and Tag Dimensions

The benchmark queries use common properties (like `account_id`, `connection_name` and `region`) and tags that are defined in the form of a default list of strings in the `mod.sp` file. These properties can be overwritten in several ways:

- Copy and rename the `steampipe.spvars.example` file to `steampipe.spvars`, and then modify the variable values inside that file
- Pass in a value on the command line:

  ```shell
  steampipe check benchmark.cis_v100 --var 'common_dimensions=["account_id", "connection_name", "region"]'
  ```

  ```shell
  steampipe check benchmark.cis_v100 --var 'tag_dimensions=["Environment", "Owner"]'
  ```

- Set an environment variable:

  ```shell
  SP_VAR_common_dimensions='["account_id", "connection_name", "region"]' steampipe check control.cis_v100_4_3
  ```

  ```shell
  SP_VAR_tag_dimensions='["Environment", "Owner"]' steampipe check control.cis_v100_4_3
  ```

## Contributing

If you have an idea for additional compliance controls, or just want to help maintain and extend this mod ([or others](https://github.com/topics/steampipe-mod)) we would love you to join the community and start contributing.

- **[Join our Slack community →](https://steampipe.io/community/join)** and hang out with other Mod developers.

Please see the [contribution guidelines](https://github.com/turbot/steampipe/blob/main/CONTRIBUTING.md) and our [code of conduct](https://github.com/turbot/steampipe/blob/main/CODE_OF_CONDUCT.md). All contributions are subject to the [Apache 2.0 open source license](https://github.com/turbot/steampipe-mod-alicloud-compliance/blob/main/LICENSE).

Want to help but not sure where to start? Pick up one of the `help wanted` issues:

- [Steampipe](https://github.com/turbot/steampipe/labels/help%20wanted)
- [Alibaba Cloud Compliance Mod](https://github.com/turbot/steampipe-mod-alicloud-compliance/labels/help%20wanted)
