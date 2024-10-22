
query "manual_control" {
  sql = <<-EOQ
    select
      'arn:acs:::' || account_id as resource,
      'info' as status,
      'Manual verification required.' as reason
      ${local.common_dimensions_global_sql}
    from
      alicloud_account;
  EOQ
}
