with network_policy_enabled as (
  select
    cluster_id
  from
    alicloud_cs_kubernetes_cluster,
    jsonb_array_elements(meta_data -> 'Addons') as a
  where
    a ->> 'name' = 'terway-eniip' and
    regexp_replace(a ->> 'config', '\\"', '"', 'g')::jsonb @> '{"NetworkPolicy":"true"}'
)
select
  -- Required Columns
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
  end as reason,
  -- Additional Dimensions
  a.region,
  a.account_id
from
  alicloud_cs_kubernetes_cluster a
  left join network_policy_enabled n on a.cluster_id = n.cluster_id;