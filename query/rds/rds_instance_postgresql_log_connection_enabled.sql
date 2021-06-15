select
  -- Required Columns
  arn as resource,
  case
    when p ->> 'ParameterValue' = 'on' then 'ok'
    else 'alarm'
  end as status,
  case
    when p ->> 'ParameterValue' = 'on' then title || ' log connection enabled.'
    else title || ' log connection not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance,
  jsonb_array_elements(parameters -> 'RunningParameters' -> 'DBInstanceParameter') as p
where
  engine = 'PostgreSQL' and p ->> 'ParameterName' = 'log_connections'