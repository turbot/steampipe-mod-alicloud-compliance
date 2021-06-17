select
  -- Required Columns
  arn as resource,
  case
    when instance_network_type = 'vpc' then 'ok'
    else 'alarm'
  end as status,
  case
    when instance_network_type = 'vpc' then title || ' has VPC network.'
    else title || ' has legacy network.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_ecs_instance;
