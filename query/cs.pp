query "cs_kubernetes_cluster_ipvlan_enabled" {
  sql = <<-EOQ
    with network_policy_enabled as (
      select
        cluster_id
      from
        alicloud_cs_kubernetes_cluster,
        jsonb_array_elements(meta_data -> 'Addons') as a
      where
        a ->> 'name' = 'terway-eniip' and
        regexp_replace(a ->> 'config', '\\"', '"', 'g') :: jsonb @> '{"IPVlan":"true"}'
    )
    select
      arn as resource,
      case
        when a.meta_data -> 'Addons' @> '[{"name": "flannel"}]' then 'skip'
        when n.cluster_id is null then 'alarm'
        else 'ok'
      end as status,
      case
        when a.meta_data -> 'Addons' @> '[{"name": "flannel"}]' then a.title || ' does not support IPVlan.'
        when n.cluster_id is null then a.title || ' IPVlan disabled.'
        else a.title || ' IPVlan enabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_cs_kubernetes_cluster a
      left join network_policy_enabled n on a.cluster_id = n.cluster_id;
  EOQ
}

query "cs_kubernetes_cluster_network_policy_enabled" {
  sql = <<-EOQ
    with network_policy_enabled as (
      select
        cluster_id
      from
        alicloud_cs_kubernetes_cluster,
        jsonb_array_elements(meta_data -> 'Addons') as a
      where
        a ->> 'name' = 'terway-eniip' and
        regexp_replace(a ->> 'config', '\\"', '"', 'g') :: jsonb @> '{"NetworkPolicy":"true"}'
    )
    select
      arn as resource,
      case
        when a.meta_data -> 'Addons' @> '[{"name": "flannel"}]' then 'skip'
        when n.cluster_id is null then 'alarm'
        else 'ok'
      end as status,
      case
        when a.meta_data -> 'Addons' @> '[{"name": "flannel"}]' then a.title || ' does not support network policy.'
        when n.cluster_id is null then a.title || ' network policy disabled.'
        else a.title || ' network policy enabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "a.")}
    from
      alicloud_cs_kubernetes_cluster a
      left join network_policy_enabled n on a.cluster_id = n.cluster_id;
  EOQ
}

query "cs_kubernetes_cluster_private_cluster_enabled" {
  sql = <<-EOQ
    select
      arn as resource,
      case
        when state != 'running' then 'skip'
        when master_url is not null
          and (master_url::jsonb->>'api_server_endpoint') is not null
          and (master_url::jsonb->>'api_server_endpoint') != ''
        then 'alarm'
        else 'ok'
      end as status,
      case
        when state != 'running' then title || ' is in ' || state || ' state.'
        when master_url is not null and (master_url::jsonb->>'api_server_endpoint') is not null
          and (master_url::jsonb->>'api_server_endpoint') != '' then name || ' has a public API server endpoint configured.'
        else name || ' is configured as a private cluster with no public API server endpoint.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      alicloud_cs_kubernetes_cluster;
  EOQ
}

query "cs_kubernetes_cluster_cloud_monitor_enabled" {
  sql = <<-EOQ
    with cluster_nodes as (
      select
        c.arn,
        c.cluster_id,
        c.title as cluster_name,
        n.instance_id,
        c.tags,
        c.region,
        c.account_id,
        c._ctx
      from
        alicloud_cs_kubernetes_cluster as c
        join alicloud_cs_kubernetes_cluster_node as n on c.cluster_id = n.cluster_id
    ),nodes_with_monitor as (
      select
        cn.arn,
        cn.cluster_id,
        cn.cluster_name,
        cn.account_id,
        cn._ctx,
        cn.tags,
        cn.region,
        count(*) as total_nodes,
        count(m.instance_id) as monitored_nodes
      from
        cluster_nodes cn
        left join alicloud_cms_monitor_host m on cn.instance_id = m.instance_id
      group by
        cn.cluster_id,
        cn.cluster_name,
        cn.arn,
        cn.tags,
        cn._ctx,
        cn.account_id,
        cn.region
    )select
      arn as resource,
      case
        when total_nodes = 0 then 'skip'
        when monitored_nodes = 0 then 'alarm'
        when monitored_nodes < total_nodes then 'alarm'
        else 'ok'
      end as status,
      case
        when total_nodes = 0 then cluster_name || ' has no nodes.'
        when monitored_nodes = 0 then cluster_name || ' cloud monitor not enabled on any node.'
        when monitored_nodes < total_nodes then cluster_name || ' cloud monitor enabled on ' || monitored_nodes || ' out of ' ||  total_nodes || '.'
        else cluster_name || ' cloud monitor enabled on all nodes.'
      end as reason
      ${local.tag_dimensions_sql}
      ${local.common_dimensions_sql}
    from
      nodes_with_monitor cn;
  EOQ
}

query "cs_kubernetes_cluster_log_service_enabled" {
  sql = <<-EOQ
    with log_service_enabled as (
      select
        cluster_id
      from
        alicloud_cs_kubernetes_cluster
      where
        meta_data -> 'AuditProjectName' is not null
        or meta_data -> 'ControlPlaneLogConfig' -> 'log_project' is not null
        or exists (
          select 1
          from jsonb_array_elements(meta_data -> 'Addons') as a
          where a ->> 'name' = 'loongcollector'
            and (a -> 'config' ->> 'sls_project_name' is not null
                 or a ->> 'config' ilike '%sls_project_name%')
        )
    )
    select
      c.arn as resource,
      case
        when c.state != 'running' then 'skip'
        when ls.cluster_id is not null then 'ok'
        else 'alarm'
      end as status,
      case
        when c.state != 'running' then c.title || ' is in ' || c.state || ' state.'
        when ls.cluster_id is not null then c.title || ' has log service enabled.'
        else c.title || ' does not have log service enabled.'
      end as reason
      ${local.tag_dimensions_sql}
      ${replace(local.common_dimensions_qualifier_sql, "__QUALIFIER__", "c.")}
    from
      alicloud_cs_kubernetes_cluster c
      left join log_service_enabled ls on c.cluster_id = ls.cluster_id;
  EOQ
}
