with bad_groups as (
  select
    distinct arn
  from
    alicloud_ecs_security_group,
    jsonb_array_elements(permissions) as p
  where
    p ->> 'Policy' = 'Accept'
    and p ->> 'Direction' = 'ingress'
    and p ->> 'SourceCidrIp' = '0.0.0.0/0'
    and (
      p ->> 'PortRange' in ('-1/-1', '22/22')
      or (22 between split_part(p ->> 'PortRange', '/', 1) :: int and split_part(p ->> 'PortRange', '/', 2) :: int)
    )
)
select
  -- Required Columns
  a.arn as resource,
  case
    when b.arn is null then 'ok'
    else 'alarm'
  end as status,
  case
    when b.arn is null then a.security_group_id || ' does not allow ingress from 0.0.0.0/0 to port 22.'
    else a.security_group_id || ' allow ingress from 0.0.0.0/0 to port 22.'
  end as reason,
  -- Additional Dimensions
  a.region,
  a.account_id
from
  alicloud_ecs_security_group as a
  left join bad_groups as b on a.arn = b.arn;