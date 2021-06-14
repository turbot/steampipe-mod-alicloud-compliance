select
  -- Required Columns
  arn as resource,
  case
    when encrypted then 'ok'
    else 'alarm'
  end as status,
  case
    when encrypted then title || ' encryption enabled.'
    else title || ' encryption not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_ecs_disk
where
  status = 'In_use';