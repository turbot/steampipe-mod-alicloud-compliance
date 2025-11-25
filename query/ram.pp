query "ram_account_password_policy_min_length_14" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when minimum_password_length >= 14 then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        else 'Minimum password length set to ' || minimum_password_length || '.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_account_password_policy_one_lowercase_letter" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when require_lowercase_characters then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        when require_lowercase_characters then 'Lowercase character required.'
        else 'Lowercase character not required.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_account_password_policy_one_number" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when require_numbers then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        when require_numbers then 'Number required.'
        else 'Number not required.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_account_password_policy_one_symbol" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when require_symbols then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        when require_symbols then 'Symbol required.'
        else 'Symbol not required.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_account_password_policy_one_uppercase_letter" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when require_uppercase_characters then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        when require_uppercase_characters then 'Uppercase character required.'
        else 'Uppercase character not required.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_account_password_policy_reuse_5" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when password_reuse_prevention = 5 then 'ok'
        else 'alarm'
      end as status,
      case
        when minimum_password_length is null then 'No password policy set.'
        when password_reuse_prevention is null then 'Password reuse prevention not set.'
        else 'Password reuse prevention set to ' || password_reuse_prevention || '.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_password_policy_expire_90" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when max_password_age <= 90 then 'ok'
        else 'alarm'
      end as status,
      case
        when max_password_age is null then 'Password expiration not set.'
        else 'Password expiration set to ' || max_password_age || ' days.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_password_policy_expire_365_or_greater" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when max_password_age is null then 'alarm'
        when max_password_age >= 365 then 'ok'
        else 'alarm'
      end as status,
      case
        when max_password_age is null then 'Password expiration not set.'
        else 'Password expiration set to ' || max_password_age || ' days.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_password_policy_max_login_attempts_5" {
  sql = <<-EOQ
    select
      'acs:ram::' || a.account_id as resource,
      case
        when max_login_attempts <= 5 then 'ok'
        else 'alarm'
      end as status,
      case
        when max_login_attempts is null then 'Max login attempts not set.'
        else 'Max login attempts set to ' || max_login_attempts || '.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_account as a
      left join alicloud_ram_password_policy as pol on a.account_id = pol.account_id;
  EOQ
}

query "ram_root_account_mfa_enabled" {
  sql = <<-EOQ
    select
      'acs:ram::' || account_id || ':user/' || user_name as resource,
      case
        when mfa_active then 'ok'
        else 'alarm'
      end as status,
      case
        when mfa_active then user_name || ' MFA enabled.'
        else user_name || ' MFA not enabled.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_credential_report
    where
      user_name = '<root>';
  EOQ
}

query "ram_root_account_no_access_keys" {
  sql = <<-EOQ
    select
      'acs:ram::' || account_id || ':user/' || user_name as resource,
      case
        when access_key_1_active or access_key_2_active then 'alarm'
        else 'ok'
      end as status,
      case
        when access_key_1_active or access_key_2_active then 'Root account access key exists.'
        else 'No root account access keys exist.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_credential_report
    where
      user_name = '<root>';
  EOQ
}

query "ram_root_account_unused" {
  sql = <<-EOQ
    select
      'acs:ram::' || account_id || ':user/' || user_name as resource,
      case
        when user_last_logon is null then 'ok'
        else 'alarm'
      end as status,
      case
        when user_last_logon is null then 'Root account not used.'
        else 'Root account last used ' || extract(day from current_date - user_last_logon) || ' days ago.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_credential_report
    where
      user_name = '<root>';
  EOQ
}

query "ram_user_access_key_rotated_90" {
  sql = <<-EOQ
    select
      'acs:ram::' || account_id || ':user/' || user_name ||  '/accesskey/' ||  access_key_id as resource,
      case
        when create_date <= (current_date - interval '90' day) then 'alarm'
        else 'ok'
      end as status,
      user_name || ' ' || access_key_id || ' created ' || to_char(create_date , 'DD-Mon-YYYY') ||
        ' (' || extract(day from current_timestamp - create_date) || ' days).'
      as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_access_key;
  EOQ
}

query "ram_user_console_access_mfa_enabled" {
  sql = <<-EOQ
    select
      'acs:ram::' || account_id || ':user/' || user_name as resource,
      case
        when password_exist and not mfa_active then 'alarm'
        else 'ok'
      end as status,
      case
        when not password_exist then user_name || ' password login disabled.'
        when password_exist and not mfa_active then user_name || ' password login enabled but no MFA device configured.'
        else user_name || ' password login enabled and MFA device configured.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_credential_report;
  EOQ
}

query "ram_user_no_policies" {
  sql = <<-EOQ
    with user_attached_with_policy as (
      select
        distinct name as user_name,
        attached_policy
      from
        alicloud_ram_user,
        jsonb_array_elements(attached_policy) as policies
      where
        attached_policy != '[]'
    )
    select
      'acs:ram::' || account_id || ':user/' || name as resource,
      case
        when u.name = p.user_name then 'alarm'
        else 'ok'
      end as status,
      case
        when u.name = p.user_name then name || ' have direct policy attached.'
        else name || ' not have any direct policy attached.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_user u
      left join user_attached_with_policy p on u.name = p.user_name;
  EOQ
}

query "ram_user_unused_90" {
  sql = <<-EOQ
    select
      'acs:ram::' || account_id || ':user/' || name as resource,
      case
        when last_login_date < current_date - interval '90 days' or last_login_date is null then 'alarm'
        else 'ok'
      end as status,
      case
        when last_login_date is null then name || ' never logged in.'
        else name || ' logged in '|| extract(day from current_date - last_login_date) || ' days ago.'
      end as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_ram_user;
  EOQ
}

query "ram_policy_no_full_wildcard_privileges" {
  sql = <<-EOQ
    with policy_statements as (
      select
        p.account_id,
        p.policy_name,
        jsonb_array_elements(coalesce(p.policy_document_std -> 'Statement', '[]'::jsonb)) as statement
      from
        alicloud_ram_policy as p
    ),
    wildcard_policies as (
      select
        account_id,
        policy_name
      from
        policy_statements
      where
        lower(coalesce(statement ->> 'Effect', '')) = 'allow'
        and (
          (jsonb_typeof(statement -> 'Action') = 'array' and (statement -> 'Action') ?| array['*', '*:*'])
          or (jsonb_typeof(statement -> 'Action') = 'string' and statement ->> 'Action' in ('*', '*:*'))
        )
        and (
          (jsonb_typeof(statement -> 'Resource') = 'array' and (statement -> 'Resource') ? '*')
          or (jsonb_typeof(statement -> 'Resource') = 'string' and statement ->> 'Resource' = '*')
        )
    )
    select
      'acs:ram::' || p.account_id || ':policy/' || p.policy_name as resource,
      case
        when w.policy_name is null then 'ok'
        else 'alarm'
      end as status,
      case
        when w.policy_name is null then p.policy_name || ' does not allow full administrative privileges.'
        else p.policy_name || ' allows all actions on all resources.'
      end as reason
      ${replace(local.common_dimensions_qualifier_global_sql, "__QUALIFIER__", "p.")}
    from
      alicloud_ram_policy as p
      left join wildcard_policies as w on p.account_id = w.account_id and p.policy_name = w.policy_name;
  EOQ
}
