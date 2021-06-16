select
  -- Required Columns
  arn as resource,
  case
    when sql_collector_retention > 180 then 'ok'
    else 'alarm'
  end as status,
  case
    when sql_collector_retention > 180 then title || ' SQL audit enabled with retention period greater than equals 6 months.'
    else title || ' SQL audit not enabled with retention greater than equals 6 months.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;