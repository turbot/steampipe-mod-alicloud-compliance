select
  -- Required Columns
  arn as resource,
  case
    when sql_collector_policy ->> 'SQLCollectorStatus' = 'Enable' then 'ok'
    else 'alarm'
  end as status,
  case
    when sql_collector_policy ->> 'SQLCollectorStatus' = 'Enable' then title || ' SQL audit enabled.'
    else title || ' SQL audit disabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;