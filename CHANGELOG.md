## v0.7 [2024-03-06]

_Powerpipe_

[Powerpipe](https://powerpipe.io) is now the preferred way to run this mod!  [Migrating from Steampipe →](https://powerpipe.io/blog/migrating-from-steampipe)

All v0.x versions of this mod will work in both Steampipe and Powerpipe, but v1.0.0 onwards will be in Powerpipe format only.

_Enhancements_

- Focus documentation on Powerpipe commands.
- Show how to combine Powerpipe mods with Steampipe plugins.

## v0.6 [2023-04-06]

_What's new?_

- Added `tags` as dimensions to group and filter findings. (see [var.tag_dimensions](https://hub.steampipe.io/mods/turbot/alicloud_compliance/variables)) ([#54](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/54))
- Added `connection_name` in the common dimensions to group and filter findings. (see [var.common_dimensions](https://hub.steampipe.io/mods/turbot/alicloud_compliance/variables)) ([#54](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/54))

_Bug fixes_

- Fixed the `cis_v100_1_14` control to be in `ok` state instead of `alarm` if maximum login attempts is less than 5. ([#48](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/48)) (Thanks [@jurajsucik](https://github.com/jurajsucik) for the contribution!)

## v0.5 [2022-05-09]

_Enhancements_

- Updated docs/index.md and README with new dashboard screenshots and latest format. ([#42](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/42))

## v0.4 [2022-05-05]

_Enhancements_

- Added `category`, `service`, and `type` tags to benchmarks and controls. ([#38](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/38))

## v0.3 [2021-09-23]

_Enhancements_

- Updated: GitHub repository cloning instructions in README.md and docs/index.md now use HTTPS instead of SSH

## v0.2 [2021-08-10]

_Bug fixes_

- Fixed: Update region column in `ecs_security_group_remote_administration`, `ecs_security_group_restrict_ingress_rdp_all` and  `ecs_security_group_restrict_ingress_ssh_all` queries ([#28](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/28)) ([#26](https://github.com/turbot/steampipe-mod-alicloud-compliance/pull/26))



## v0.1 [2021-06-17]

_What's new?_

- Initial release with CIS v1.0.0 benchmark (`steampipe check benchmark.cis_v100`)
