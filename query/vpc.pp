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
    from
      vpc_list v
      left join flow_logs fl on v.vpc_id = fl.resource_id and v.region = fl.region and v.account_id = fl.account_id;
  EOQ
}
