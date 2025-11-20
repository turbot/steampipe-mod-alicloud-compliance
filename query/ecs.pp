query "ecs_disk_encryption_enabled" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when encrypted then 'ok'
        else 'alarm'
      end as status,
      case
        when encrypted then title || ' encryption enabled.'
        else title || ' encryption disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_ecs_disk
    where
      status = 'In_use';
  EOQ
}

query "ecs_instance_with_no_legacy_network" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when instance_network_type = 'vpc' then 'ok'
        else 'alarm'
      end as status,
      case
        when instance_network_type = 'vpc' then title || ' has VPC network.'
        else title || ' has legacy network.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_ecs_instance;
  EOQ
}

query "ecs_security_group_remote_administration" {
  sql = <<-EOQ
    with bad_groups as (
      select
        distinct arn
      from
        alicloud_ecs_security_group,
        jsonb_array_elements(permissions) as p
      where
        p ->> 'Policy' = 'Accept'
        and p ->> 'Direction' = 'ingress'
        and p ->> 'SourceCidrIp' = '0.0.0.0/0'
        and (
          p ->> 'PortRange' in ('-1/-1', '22/22', '3389/3389')
          or (
            3389 between split_part(p ->> 'PortRange', '/', 1) :: int and split_part(p ->> 'PortRange', '/', 2) :: int
            or 22 between split_part(p ->> 'PortRange', '/', 1) :: int and split_part(p ->> 'PortRange', '/', 2) :: int
          )
        )
    )
    select
      a.arn as resource,
      case
        when b.arn is null then 'ok'
        else 'alarm'
      end as status,
      case
        when b.arn is null then a.security_group_id || ' does not allow ingress from 0.0.0.0/0 to port 22 or 3389.'
        else a.security_group_id || ' allow ingress from 0.0.0.0/0 to port 22 or 3389.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_ecs_security_group as a
      left join bad_groups as b on a.arn = b.arn;
  EOQ
}

query "ecs_security_group_restrict_ingress_rdp_all" {
  sql = <<-EOQ
    with bad_groups as (
      select
        distinct arn
      from
        alicloud_ecs_security_group,
        jsonb_array_elements(permissions) as p
      where
        p ->> 'Policy' = 'Accept'
        and p ->> 'Direction' = 'ingress'
        and p ->> 'SourceCidrIp' = '0.0.0.0/0'
        and (
          p ->> 'PortRange' in ('-1/-1', '3389/3389')
          or (3389 between split_part(p ->> 'PortRange', '/', 1) :: int and split_part(p ->> 'PortRange', '/', 2) :: int)
        )
    )
    select
      a.arn as resource,
      case
        when b.arn is null then 'ok'
        else 'alarm'
      end as status,
      case
        when b.arn is null then a.security_group_id || ' does not allow ingress from 0.0.0.0/0 to port 3389.'
        else a.security_group_id || ' allow ingress from 0.0.0.0/0 to port 3389.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_ecs_security_group as a
    left join bad_groups as b on a.arn = b.arn;
  EOQ
}

query "ecs_security_group_restrict_ingress_ssh_all" {
  sql = <<-EOQ
    with bad_groups as (
      select
        distinct arn
      from
        alicloud_ecs_security_group,
        jsonb_array_elements(permissions) as p
      where
        p ->> 'Policy' = 'Accept'
        and p ->> 'Direction' = 'ingress'
        and p ->> 'SourceCidrIp' = '0.0.0.0/0'
        and (
          p ->> 'PortRange' in ('-1/-1', '22/22')
          or (22 between split_part(p ->> 'PortRange', '/', 1) :: int and split_part(p ->> 'PortRange', '/', 2) :: int)
        )
    )
    select
      a.arn as resource,
      case
        when b.arn is null then 'ok'
        else 'alarm'
      end as status,
      case
        when b.arn is null then a.security_group_id || ' does not allow ingress from 0.0.0.0/0 to port 22.'
        else a.security_group_id || ' allow ingress from 0.0.0.0/0 to port 22.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_ecs_security_group as a
      left join bad_groups as b on a.arn = b.arn;
  EOQ
}

query "ecs_unattached_disk_encryption_enabled" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when encrypted then 'ok'
        else 'alarm'
      end as status,
      case
        when  encrypted then  title || ' encryption enabled.'
        else  title || ' encryption disabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_ecs_disk
    where
      status = 'Available';
  EOQ
}

query "ecs_security_center_agent_installed" {
  sql = <<-EOQ
    with instances_with_agent as (
      select
        instance_id,
        instance_name,
        client_status,
        client_version,
        region,
        account_id
      from
        alicloud_security_center_asset
      where
        client_status IN ('online', 'offline')
    )
    select
      arn as resource,
      case
        when i.status <> 'Running' then 'skip'
        when sca.client_status in ('online', 'offline') then 'ok'
        else 'alarm'
      end as status,
      case
        when i.status <> 'Running' then i.title || ' is not running.'
        when sca.client_status = 'online' then i.title || ' has Security Center agent installed and online.'
        when sca.client_status = 'offline' then i.title || ' has Security Center agent installed but is offline.'
        else i.title || ' does not have Security Center agent installed.'
      end as reason
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "i.")}
    from
      alicloud_ecs_instance i
      left join instances_with_agent sca on i.instance_id = sca.instance_id and i.region = sca.region and i.account_id = sca.account_id;
  EOQ
}

query "ecs_instance_latest_os_patches_applied" {
  sql = <<-EOQ
    with instances_with_unfixed_vulns as (
      select distinct
        instance_id,
        instance_name,
        region,
        account_id,
        count(*) as unfixed_vulnerability_count
      from
        alicloud_security_center_vulnerability
      where
        status = 0  -- 0 = unfixed
        and instance_id is not null
        and instance_id != ''
      group by
        instance_id,
        instance_name,
        region,
        account_id
    )
    select
      arn as resource,
      case
        when i.status != 'Running' then 'skip'
        when iv.unfixed_vulnerability_count > 0 then 'alarm'
        else 'ok'
      end as status,
      case
        when i.status != 'Running' then i.title || ' is not in Running state.'
        when iv.unfixed_vulnerability_count > 0 then i.title || ' has ' || iv.unfixed_vulnerability_count || ' unfixed vulnerabilities.'
        else i.title || ' has all OS patches applied - no unfixed vulnerabilities found.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "i.")}
    from
      alicloud_ecs_instance i
      left join instances_with_unfixed_vulns iv on i.instance_id = iv.instance_id and i.region = iv.region and i.account_id = iv.account_id
  EOQ
}
