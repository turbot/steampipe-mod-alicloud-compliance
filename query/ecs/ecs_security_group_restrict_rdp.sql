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
      p ->> 'PortRange' in ('-1/-1', '3389/3389')
      or ( 3389 between split_part(p ->> 'PortRange' :: text, '/', 1) :: int and split_part(p ->> 'PortRange' :: text, '/', 2) :: int )
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
    when b.arn is null then a.security_group_id || ' does not allow ingress from 0.0.0.0/0 to port 3389.'
    else a.security_group_id || ' allow ingress from 0.0.0.0/0 to port 3389.'
  end as reason,
  -- Additional Dimensions
  a.region_id,
  a.account_id
from
  alicloud_ecs_security_group as a
left join bad_groups as b on a.arn = b.arn;