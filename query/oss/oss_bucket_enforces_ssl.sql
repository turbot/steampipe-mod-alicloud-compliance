with ssl_ok as (
  select
    distinct name,
    'ok' as status
  from
    alicloud_oss_bucket,
    jsonb_array_elements(policy -> 'Statement') as s,
    jsonb_array_elements_text(s -> 'Principal') as p,
    jsonb_array_elements_text(s -> 'Resource') as r,
    jsonb_array_elements_text(
      s -> 'Condition' -> 'Bool' -> 'acs:SecureTransport'
    ) as ssl
  where
    p = '*'
    and s ->> 'Effect' = 'Deny'
    and ssl :: bool = false
)
select
  -- Required Columns
  'acs:oss:::' || b.name as resource,
  case
    when ok.status = 'ok' then 'ok'
    else 'alarm'
  end status,
  case
    when ok.status = 'ok' then b.title || ' bucket policy enforces HTTPS.'
    else b.title || ' bucket policy does not enforce HTTPS.'
  end reason,
  -- Additional Dimensions
  b.region,
  b.account_id
from
  alicloud_oss_bucket as b
  left join ssl_ok as ok on ok.name = b.name;