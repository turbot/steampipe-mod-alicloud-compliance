query "vpc_flow_logs_enabled" {
  sql = <<-EOQ
    with vpc_list as (
      select
        vpc_id,
        arn,
        title,
        region,
        account_id,
        _ctx,
        tags
      from
        alicloud_vpc
    ), flow_logs as (
      select
        flow_log_id,
        title,
        status as flow_log_status,
        resource_id,
        region,
        account_id
      from
        alicloud_vpc_flow_log
      where
        resource_type = 'VPC'
    )
    select
      arn as resource,
      case
        when fl.flow_log_id is not null and fl.flow_log_status = 'Active' then 'ok'
        when fl.flow_log_id is not null and fl.flow_log_status <> 'Active' then 'alarm'
        else 'alarm'
      end as status,
      case
        when fl.flow_log_id is not null and fl.flow_log_status = 'Active' then v.title || ' has VPC flow logging enabled.'
        when fl.flow_log_id is not null and fl.flow_log_status <> 'Active' then v.title || ' flow logging enabled but inactive.'
        else v.title || ' does not have VPC flow logging enabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
    from
      vpc_list v
      left join flow_logs fl on v.vpc_id = fl.resource_id and v.region = fl.region and v.account_id = fl.account_id;
  EOQ
}

query "vpc_and_vswitch_flow_log_integrated_with_log_service" {
  sql = <<-EOQ
    with compliant_flow_logs as (
      select
        resource_id,
        resource_type,
        project_name,
        log_store_name,
        region,
        account_id,
        name as flow_log_name
      from
        alicloud_vpc_flow_log
      where
        resource_type in ('VPC', 'VSwitch')
        and status = 'Active'
        and project_name is not null
        and project_name != ''
        and log_store_name is not null
        and log_store_name != ''
    )
    select
      arn as resource,
      case
        when fl.resource_id is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when fl.resource_id is not null then v.title || ' has active flow log "' || fl.flow_log_name || '" integrated with log service (project: ' || fl.project_name || ', logstore: ' || fl.log_store_name || ').'
        else v.title || ' does not have an active flow log integrated with log service'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "v.")}
    from
      alicloud_vpc v
      left join compliant_flow_logs fl on v.vpc_id = fl.resource_id and v.region = fl.region and v.account_id = fl.account_id and fl.resource_type = 'VPC'
    union all
    select
      'acs:vpc:' || vs.region || ':' || vs.account_id || ':vswitch/' || vs.vswitch_id as resource,
      case
        when fl.resource_id is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when fl.resource_id is not null then vs.title || ' has active flow log "' || fl.flow_log_name || '" integrated with log service (project: ' || fl.project_name || ', logstore: ' || fl.log_store_name || ').'
        else vs.title || ' does not have an active flow log integrated with log service.'
      end as reason
       ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "vs.")}
    from
      alicloud_vpc_vswitch vs
      left join compliant_flow_logs fl on vs.vswitch_id = fl.resource_id and vs.region = fl.region and vs.account_id = fl.account_id and fl.resource_type = 'VSwitch';
  EOQ
}
