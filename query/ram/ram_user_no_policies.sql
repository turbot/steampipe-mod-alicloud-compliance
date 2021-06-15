with user_attached_with_policy as (
  select
    distinct name as user_name,
    attached_policy
  from
    alicloud_ram_user,
    jsonb_array_elements(attached_policy) as policies
  where
    attached_policy != '[]'
)
select
  -- Required Columns
  'acs:ram::' || account_id || ':user/' || name as resource,
 case
    when u.name = p.user_name then 'alarm'
    else 'ok'
  end as status,
  case
    when u.name = p.user_name then name || ' have direct policy attached.'
    else name || ' not have any direct policy attached.'
  end as reason,
  -- Additional Dimensions
  account_id
from
  alicloud_ram_user u
  left join user_attached_with_policy p on u.name = p.user_name;