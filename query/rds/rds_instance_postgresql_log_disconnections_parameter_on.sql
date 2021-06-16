select
  -- Required Columns
  arn as resource,
  case
    when p ->> 'ParameterValue' = 'on' then 'ok'
    else 'alarm'
  end as status,
  case
    when p ->> 'ParameterValue' = 'on' then title || ' ''log_disconnections'' parameter set to ''on''.'
    else title || ' ''log_disconnections'' parameter set to ''off''.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance,
  jsonb_array_elements(parameters -> 'RunningParameters' -> 'DBInstanceParameter') as p
where
  engine = 'PostgreSQL' and p ->> 'ParameterName' = 'log_disconnections';