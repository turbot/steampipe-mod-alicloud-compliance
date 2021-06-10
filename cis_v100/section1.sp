locals {
  cis_v100_1_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "1"
  })
}

benchmark "cis_v100_1" {
  title         = "1 Identity and Access Management"
  #documentation = file("./cis_v100/docs/cis_v100_1.md")
  children = [
    control.cis_v100_1_1,
    control.cis_v100_1_2,
    control.cis_v100_1_3,
    control.cis_v100_1_4,
    control.cis_v100_1_5,
    control.cis_v100_1_6,
    control.cis_v100_1_7,
    control.cis_v100_1_8,
    control.cis_v100_1_9,
    control.cis_v100_1_10,
    control.cis_v100_1_11,
    control.cis_v100_1_12,
    control.cis_v100_1_13,
    control.cis_v100_1_14,
    control.cis_v100_1_16
  ]
  tags          = local.cis_v100_1_common_tags
}

control "cis_v100_1_1" {
  title         = "1.1 Avoid the use of the 'root' account"
  description   = "An Alibaba Cloud account can be viewed as a 'root' account. The 'root' account has full control permissions to all cloud products and resources under such account. It is highly recommended that the use of this account should be avoided."
  sql           = query.ram_root_account_use_avoided.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_1.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.1"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v100_1_2" {
  title         = "1.2 Ensure no root account access key exists"
  description   = "Access keys provide programmatic access to a given Alibaba Cloud account. It is recommended that all access keys associated with the root account be removed."
  sql           = query.ram_root_account_access_key.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_2.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.2"
    cis_level   = "1"
    cis_type    = "manual"
  })
}

control "cis_v100_1_3" {
  title         = "1.3 Ensure MFA is enabled for the 'root' account"
  description   = "With MFA enabled, anytime the “root” account logs on to Alibaba Cloud, it will be prompted for username and password followed by an authentication code from the virtual MFA device.It is recommended that MFA be enabled for the 'root' user."
  sql           = query.ram_root_account_mfa_enabled.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_3.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.3"
    cis_level   = "1"
    cis_type    = "manual"
  })
}
#check
control "cis_v100_1_4" {
  title         = "1.4 Ensure that multi-factor authentication is enabled for all RAM users that have a console password"
  description   = "Multi-Factor Authentication (MFA) adds an extra layer of protection on top of a username and password. With MFA enabled, when a user logs on to Alibaba Cloud, they will be prompted for their user name and password followed by an authentication code from their virtual MFA device. It is recommended that MFA be enabled for all users that have a console password."
  sql           = query.ram_root_account_mfa_enabled.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_4.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_5" {
  title         = "1.5 Ensure users not logged on for 90 days or longer are disabled for console logon"
  description   = "Alibaba Cloud RAM users can logon to Alibaba Cloud console by using their user name and password. If a user has not logged on for 90 days or longer, it is recommended to disable the console access of the user."
  sql           = query.ram_user_unused_90.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_5.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_6" {
  title         = "1.6 Ensure access keys are rotated every 90 days or less"
  description   = "An access key consists of an access key ID and a secret, which are used to sign programmatic requests that you make to Alibaba Cloud. RAM users need their own access keys to make programmatic calls to Alibaba Cloud from the Alibaba Cloud SDKs, CLIs, or direct HTTP/HTTPS calls using the APIs for individual Alibaba Cloud services. It is recommended that all access keys be regularly rotated."
  sql           = query.ram_user_access_key_rotated_90.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_6.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.6"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_7" {
  title         = "1.7 Ensure RAM password policy requires at least one uppercase letter"
  description   = "RAM password policies can be used to ensure password complexity. It is recommended that the password policy require at least one uppercase letter."
  sql           = query.ram_account_password_policy_one_uppercase_letter.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_7.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.7"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_8" {
  title         = "1.8 Ensure RAM password policy requires at least one lowercase letter"
  description   = "RAM password policies can be used to ensure password complexity. It is recommended that the password policy require at least one lowercase letter."
  sql           = query.ram_account_password_policy_one_lowercase_letter.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_8.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.8"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_9" {
  title         = "1.8 Ensure RAM password policy require at least one symbol"
  description   = "RAM password policies can be used to ensure password complexity. It is recommended that the password policy require at least one symbol."
  sql           = query.ram_account_password_policy_one_symbol.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_9.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.9"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_10" {
  title         = "1.10 Ensure RAM password policy require at least one number"
  description   = "RAM password policies can be used to ensure password complexity. It is recommended that the password policy require at least one number."
  sql           = query.ram_account_password_policy_one_number.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_10.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.10"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_11" {
  title         = "1.11 Ensure RAM password policy requires minimum length of 14 or greater"
  description   = "RAM password policies can be used to ensure password complexity. It is recommended that the password policy require a minimum of 14 or greater characters for any password."
  sql           = query.ram_account_password_policy_min_length_14.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_11.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.11"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_12" {
  title         = "1.12 Ensure RAM password policy prevents password reuse"
  description   = "It is recommended that the password policy prevent the reuse of passwords."
  sql           = query.ram_account_password_policy_reuse.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_12.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.12"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_13" {
  title         = "1.13 Ensure RAM password policy expires passwords within 90 days or less"
  description   = "RAM password policies can require passwords to be expired after a given number of days. It is recommended that the password policy expire passwords after 90 days or less."
  sql           = query.ram_password_policy_expire_90.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_13.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.13"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_14" {
  title         = "1.14 Ensure RAM password policy temporarily blocks logon after 5 incorrect logon attempts within an hour"
  description   = "RAM password policies can require passwords to be expired after a given number of days. It is recommended that the password policy expire passwords after 90 days or less."
  sql           = query.ram_password_policy_incorrect_login_block.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_14.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.14"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_1_16" {
  title         = "1.16 Ensure RAM policies are attached only to groups or roles"
  description   = "By default, RAM users, groups, and roles have no access to Alibaba Cloud resources. RAM policies are the means by which privileges are granted to users, groups, or roles. It is recommended that RAM policies be applied directly to groups and roles but not users."
  sql           = query.ram_policy_attached_to_group_and_role.sql
  #documentation = file("./cis_v100/docs/cis_v100_1_16.md")

  tags = merge(local.cis_v100_1_common_tags, {
    cis_item_id = "1.16"
    cis_level   = "1"
    cis_type    = "automated"
  })
}