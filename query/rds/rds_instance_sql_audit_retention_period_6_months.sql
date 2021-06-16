select
  -- Required Columns
  arn as resource,
  case
    when sql_collector_retention > 180 then 'ok'
    else 'alarm'
  end as status,
  title || ' SQL audit enabled with retention period ' || sql_collector_retention || '.'
  as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;