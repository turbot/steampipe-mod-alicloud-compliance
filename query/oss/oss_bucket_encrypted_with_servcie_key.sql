select
  -- Required Columns
  'acs:oss:::' || b.name as resource,
  case
    when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = 'Oss' then 'ok'
    else 'alarm'
  end as status,
  case
    when server_side_encryption ->> 'SSEAlgorithm' = 'KMS' and k.creator = 'Oss' then b.title || ' encrypted with Service Key.'
    else b.title || ' not encrypted with Service Key.'
  end as reason,
  -- Additional Dimensions
  b.region,
  b.account_id
from
  alicloud_oss_bucket b
  left join alicloud_kms_key k on b.server_side_encryption ->> 'KMSMasterKeyID' = k.key_id;