select
  -- Required Columns
  account_id as resource,
  case
    when version in ('2', '3', '5') then 'ok'
    else 'alarm'
  end as status,
  case
    when version in ('2','3') then 'Security Center Enterprise edition enabled.'
    when version in ('5') then 'Security Center Advanced edition enabled.'
    else 'Security Center Enterprise or Advanced not enabled.'
  end as reason,
  -- Additional Dimensions
  region,
  account_id
from
  alicloud_security_center_version;