with network_policy_enabled as (
  select
    cluster_id
  from
    alicloud_cs_kubernetes_cluster,
    jsonb_array_elements(meta_data -> 'Addons' ) as a
  where
    a ->> 'name' = 'terway-eniip' and
    regexp_replace(a ->> 'config', '\\"', '"', 'g')::jsonb @> '{"IPVlan":"true"}'
)
select
  -- Required Columns
  'arn:acs:cs:' || region || ':' || account_id || ':cluster/' || a.cluster_id as resource,
  case
    when n.cluster_id is null then 'alarm'
    else 'ok'
  end as status,
  case
    when n.cluster_id is null then title || ' IPVlan disabled.'
    else title || ' IPVlan enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_cs_kubernetes_cluster a
  left join network_policy_enabled n on a.cluster_id = n.cluster_id;