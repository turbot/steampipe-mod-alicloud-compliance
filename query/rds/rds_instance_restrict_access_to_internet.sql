select
  -- Required Columns
  arn as resource,
  case
    when security_ips :: jsonb ? '0.0.0.0/0' then 'alarm'
    else 'ok'
  end as status,
  case
    when security_ips :: jsonb ? '0.0.0.0/0' then title || ' publicly accessible.'
    else title || ' not publicly accessible.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_rds_instance;