select
  -- Required Columns
  arn as resource,
  case
    when security_ips :: jsonb ? '0.0.0.0/0' then 'alarm'
    else 'ok'
  end as status,
  case
    when security_ips :: jsonb ? '0.0.0.0/0' then title || ' open to world.'
    else title || ' not open to world.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;