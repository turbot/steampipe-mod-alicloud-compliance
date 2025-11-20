query "sls_alert_ram_role_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="ResourceManager"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Ram"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "ResourceManager"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Ram"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreatePolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeletePolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreatePolicyVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="UpdatePolicyVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="SetDefaultPolicyVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeletePolicyVersion"%'
          -- optional: JSON-style variants
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreatePolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeletePolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreatePolicyVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "UpdatePolicyVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "SetDefaultPolicyVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeletePolicyVersion"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a RAM policy change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no RAM policy change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_cloud_firewall_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Cloudfw"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="CloudFirewall"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Cloudfw"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "CloudFirewall"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateVpcFirewallControlPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteVpcFirewallControlPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyVpcFirewallControlPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateVpcFirewallControlPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteVpcFirewallControlPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyVpcFirewallControlPolicy"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a Cloud Firewall rule change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no Cloud Firewall rule change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_vpc_route_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Ecs"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Vpc"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Ecs"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Vpc"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateRouteEntry"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteRouteEntry"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyRouteEntry"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="AssociateRouteTable"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="UnassociateRouteTable"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateRouteEntry"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteRouteEntry"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyRouteEntry"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "AssociateRouteTable"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "UnassociateRouteTable"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a VPC network route change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no VPC network route change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_vpc_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Ecs"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Vpc"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Ecs"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Vpc"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateVpc"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteVpc"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DisableVpcClassicLink"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="EnableVpcClassicLink"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeletionProtection"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="AssociateVpcCidrBlock"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="UnassociateVpcCidrBlock"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="RevokeInstanceFromCen"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateVSwitch"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteVSwitch"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateVpc"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteVpc"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DisableVpcClassicLink"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "EnableVpcClassicLink"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeletionProtection"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "AssociateVpcCidrBlock"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "UnassociateVpcCidrBlock"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "RevokeInstanceFromCen"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateVSwitch"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteVSwitch"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a VPC change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no VPC change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_root_account_usage" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName%ConsoleSignin%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName":%ConsoleSignin%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.userIdentity.type%root-account%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.userIdentity.type":%root-account%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%userIdentity.type%root-account%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"userIdentity.type":%root-account%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%root-account%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a root account usage monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no root account usage monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_oss_bucket_policy_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="PutBucketLifecycle"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="PutBucketPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="PutBucketCors"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="PutBucketEncryption"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="PutBucketReplication"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteBucketPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteBucketCors"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteBucketLifecycle"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteBucketEncryption"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteBucketReplication"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "PutBucketLifecycle"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "PutBucketPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "PutBucketCors"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "PutBucketEncryption"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "PutBucketReplication"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteBucketPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteBucketCors"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteBucketLifecycle"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteBucketEncryption"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteBucketReplication"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has an OSS bucket policy change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no OSS bucket policy change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_security_group_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="AuthorizeSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="AuthorizeSecurityGroupEgress"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="RevokeSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="RevokeSecurityGroupEgress"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="JoinSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="LeaveSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifySecurityGroupPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "AuthorizeSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "AuthorizeSecurityGroupEgress"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "RevokeSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "RevokeSecurityGroupEgress"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "JoinSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "LeaveSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteSecurityGroup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifySecurityGroupPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: CreateSecurityGroup%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: AuthorizeSecurityGroup%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: AuthorizeSecurityGroupEgress%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: RevokeSecurityGroup%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: RevokeSecurityGroupEgress%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: JoinSecurityGroup%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: LeaveSecurityGroup%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: DeleteSecurityGroup%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event_name: ModifySecurityGroupPolicy%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a security group change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no security group change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_kms_key_disable_deletion" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Kms"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="KMS"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Kms"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "KMS"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DisableKey"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ScheduleKeyDeletion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteKeyMaterial"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DisableKey"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ScheduleKeyDeletion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteKeyMaterial"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a KMS key disable/deletion monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no KMS key disable/deletion monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_console_authentication_failures" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName%ConsoleSignin%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName":%ConsoleSignin%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%not%"event.errorCode"%""%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%not%event.errorCode%""%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%errorCode%*%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a console authentication failure monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no console authentication failure monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_console_signin_without_mfa" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName%ConsoleSignin%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName":%ConsoleSignin%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%addionalEventData.loginAccount%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%additionalEventData.loginAccount%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"addionalEventData.loginAccount":%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"additionalEventData.loginAccount":%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%loginAccount%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%mfa%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%MfaUsed%false%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%MFA%false%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a console sign-in without MFA monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no console sign-in without MFA monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_unauthorized_api_calls" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventType%ApiCall%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventType":%ApiCall%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%NoPermission%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%Forbidden%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%Forbbiden%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%InvalidAccessKeyId%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%InvalidSecurityToken%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%SignatureDoesNotMatch%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%InvalidAuthorization%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%AccessForbidden%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.errorCode%NotAuthorized%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"NoPermission%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"Forbidden%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"Forbbiden%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"InvalidAccessKeyId%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"InvalidSecurityToken%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"SignatureDoesNotMatch%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"InvalidAuthorization%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"AccessForbidden%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.errorCode":%"NotAuthorized%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has an unauthorized API call monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no unauthorized API call monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_rds_configuration_changes" {
  sql = <<-EOQ
    with actiontrail_check as (
      select
        name as trail_name,
        account_id,
        status,
        sls_project_arn,
        sls_write_role_arn,
        home_region,
        trail_region,
        substring(sls_project_arn from 'acs:log:([^:]+):') as sls_region,
        substring(sls_project_arn from 'project/([^/]+)') as sls_project_name
      from
        alicloud_action_trail
      where
        status = 'Enable' and sls_project_arn is not null
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="rds"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.serviceName="Rds"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "rds"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.serviceName": "Rds"%'
        )
        and (
          coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyHASwitchConfig"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceHAConfig"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="SwitchDBInstanceHA"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceSpec"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="MigrateSecurityIPMode"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifySecurityIps"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceSSL"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="MigrateToOtherZone"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="UpgradeDBInstanceKernelVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="UpgradeDBInstanceEngineVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceMaintainTime"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceAutoUpgradeMinorVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="AllocateInstancePublicConnection"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceConnectionString"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceNetworkExpireTime"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ReleaseInstancePublicConnection"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="SwitchDBInstanceNetType"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDBInstanceNetworkType"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyDTCSecurityIpHostsForSQLServer"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifySecurityGroupConfiguration"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateBackup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyBackupPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="DeleteBackup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="CreateDdrInstance"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%event.eventName="ModifyInstanceCrossBackupPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyHASwitchConfig"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceHAConfig"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "SwitchDBInstanceHA"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceSpec"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "MigrateSecurityIPMode"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifySecurityIps"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceSSL"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "MigrateToOtherZone"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "UpgradeDBInstanceKernelVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "UpgradeDBInstanceEngineVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceMaintainTime"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceAutoUpgradeMinorVersion"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "AllocateInstancePublicConnection"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceConnectionString"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceNetworkExpireTime"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ReleaseInstancePublicConnection"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "SwitchDBInstanceNetType"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDBInstanceNetworkType"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyDTCSecurityIpHostsForSQLServer"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifySecurityGroupConfiguration"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateBackup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyBackupPolicy"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "DeleteBackup"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "CreateDdrInstance"%'
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%"event.eventName": "ModifyInstanceCrossBackupPolicy"%'
        )
    ),
    matched_pairs as (
      select distinct
        at.trail_name,
        at.sls_region,
        at.home_region,
        ac.alert_name,
        ac.region as alert_region
      from
        actiontrail_check at
        inner join alert_check ac on
          trim(lower(coalesce(at.sls_region, ''))) = trim(lower(coalesce(ac.region, '')))
          and at.sls_region is not null
          and ac.region is not null
          and at.sls_region != ''
          and ac.region != ''
    )
    select
      'acs:actiontrail:' || at.home_region || ':' || at.account_id || ':actiontrail/' || at.name as resource,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then 'ok'
        else 'alarm'
      end as status,
      case
        when at.status = 'Enable' and at.sls_project_arn is not null and exists (select 1 from matched_pairs mp where mp.trail_name = at.name) then at.name || ' is configured with ActionTrail enabled, delivering to SLS project in region '
          || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', and has a RDS instance configuration change monitoring alert configured'
        when at.status = 'Enable' and at.sls_project_arn is not null then at.name || ' is configured with ActionTrail enabled and delivering to SLS project in region ' || substring(at.sls_project_arn from 'acs:log:([^:]+):') || ', but no RDS instance configuration change monitoring alert found in that region'
        when at.status = 'Enable' and at.sls_project_arn is null then at.name || ' is enabled but not configured to deliver logs to SLS'
        else at.name || ' is not enabled'
      end as reason
      --${local.common_dimensions_sql}
    from
      alicloud_action_trail at;
  EOQ
}

query "sls_alert_oss_permission_changes" {
  sql = <<-EOQ
    with oss_log_check as (
      select
        distinct project,
        region
      from
        alicloud_sls_logstore
      where
        name ilike '%oss%' or name ilike '%oss_log%'
    ), alert_check as (
      select
        project,
        region,
        name as alert_name,
        display_name,
        status as alert_status,
        coalesce(
          query_obj ->> 'Query',
          query_obj ->> 'query',
          query_obj::text
        ) as query_text
      from
        alicloud_sls_alert,
        jsonb_array_elements(query_list) as query_obj
      where
        (status = 'ENABLED' or status is null) and query_list is not null
        and (
          (
            coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%operation:%PutBucket%'
            and coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%request_uri:%acl%'
          )
          or coalesce(query_obj ->> 'Query', query_obj ->> 'query', query_obj::text) ilike '%operation:%PutObjectAcl%'
        )
    ),
    matched_pairs as (
      select distinct
        olc.project,
        olc.region,
        ac.alert_name
      from
        oss_log_check olc
        inner join alert_check ac on
          trim(lower(coalesce(olc.project, ''))) = trim(lower(coalesce(ac.project, '')))
          and trim(lower(coalesce(olc.region, ''))) = trim(lower(coalesce(ac.region, '')))
          and olc.project is not null
          and ac.project is not null
          and olc.region is not null
          and ac.region is not null
    )
    select
      'acs:sls:' || coalesce(mp.region, olc.region, '') || ':' || coalesce(mp.project, olc.project, '') || ':oss-permission-monitoring' as resource,
      case
        when mp.alert_name is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when mp.alert_name is not null then 'OSS log monitoring is configured in SLS project ' || mp.project || ' (region ' || mp.region || '), and has an OSS permission change monitoring alert configured'
        when olc.project is not null then 'OSS logs are enabled in SLS project ' || olc.project || ' (region ' || olc.region || ') but no OSS permission change monitoring alert found. Ensure an alert is configured for PutBucket ACL or PutObjectAcl operations'
        else 'OSS permission change monitoring alert not found. Ensure OSS logs are enabled in SLS and an alert is configured for PutBucket ACL or PutObjectAcl operations'
      end as reason
      --${local.common_dimensions_sql}
    from
      oss_log_check olc
      left join matched_pairs mp on olc.project = mp.project and olc.region = mp.region;
  EOQ
}


