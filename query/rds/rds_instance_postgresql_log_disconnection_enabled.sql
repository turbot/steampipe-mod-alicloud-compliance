select
  -- Required Columns
  arn as resource,
  case
    when p ->> 'ParameterValue' = 'on' then 'ok'
    else 'alarm'
  end as status,
  case
    when p ->> 'ParameterValue' = 'on' then title || ' log disconnections enabled.'
    else title || ' log disconnections not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance,
  jsonb_array_elements(parameters -> 'RunningParameters' -> 'DBInstanceParameter') as p
where
  engine = 'PostgreSQL' and p ->> 'ParameterName' = 'log_disconnections';