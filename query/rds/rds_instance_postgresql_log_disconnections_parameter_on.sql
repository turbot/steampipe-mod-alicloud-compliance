select
  -- Required Columns
  arn as resource,
  case
    when engine != 'PostgreSQL' then 'skip'
    when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_disconnections", "ParameterValue": "on"}]' then 'ok'
    else 'alarm'
  end as status,
  case
    when engine != 'PostgreSQL' then title || ' is ' || engine || ' server.'
    when parameters -> 'RunningParameters' -> 'DBInstanceParameter' @> '[{"ParameterName": "log_disconnections", "ParameterValue": "on"}]' then title || ' ''log_disconnections'' parameter set to ''on''.'
    else title || ' ''log_disconnections'' parameter set to ''off''.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;