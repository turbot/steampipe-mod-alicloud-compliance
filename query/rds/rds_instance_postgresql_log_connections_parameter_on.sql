select
  -- Required Columns
  arn as resource,
  case
    when engine != 'PostgreSQL' then 'skip'
    when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_connections", "ParameterValue": "on"}]' then 'ok'
    else 'alarm'
  end as status,
  case
    when engine != 'PostgreSQL' then title || ' is ' || engine || ' server.'
    when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_connections", "ParameterValue": "on"}]' then title || ' ''log_connections'' parameter set to ''on''.'
    else title || ' ''log_connections'' parameter set to ''off''.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;