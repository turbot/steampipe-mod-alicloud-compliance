select
  -- Required Columns
  'arn:acs:oss:::' || b.name as resource,
  case
    when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = k.account_id then 'ok'
    else 'alarm'
  end as status,
  case
    when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = k.account_id then b.title || ' encrypted with BYOK.'
    else b.title || ' not encrypted with BYOK.'
  end as reason,
  -- Additional Dimensions
  b.region,
  b.account_id
from
  alicloud_oss_bucket b
  left join alicloud_kms_key k on b.server_side_encryption ->> 'KMSMasterKeyID' = k.key_id;