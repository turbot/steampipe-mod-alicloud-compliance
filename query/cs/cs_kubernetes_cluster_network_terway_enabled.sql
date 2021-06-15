select
  -- Required Columns
  'arn:acs:cs:' || region || ':' || account_id || ':cluster/' || cluster_id as resource,
  case
    when meta_data -> 'Capabilities' ->> 'Network' = 'terway-eniip' then 'ok'
    else 'alarm'
  end as status,
  case
    when meta_data -> 'Capabilities' ->> 'Network' = 'terway-eniip' then title || ' Terway network enabled.'
    else title || ' Terway network not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_cs_kubernetes_cluster;