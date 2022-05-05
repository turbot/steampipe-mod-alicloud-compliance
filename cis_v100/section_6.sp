locals {
  cis_v100_6_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "6"
  })
}

benchmark "cis_v100_6" {
  title         = "6 Relational Database Services"
  documentation = file("./cis_v100/docs/cis_v100_6.md")
  children = [
    control.cis_v100_6_1,
    control.cis_v100_6_2,
    control.cis_v100_6_3,
    control.cis_v100_6_4,
    control.cis_v100_6_5,
    control.cis_v100_6_7,
    control.cis_v100_6_8,
    control.cis_v100_6_9,
    ]

  tags = merge(local.cis_v100_6_common_tags, {
    service = "AliCloud/RDS"
    type    = "Benchmark"
  })
}

control "cis_v100_6_1" {
  title         = "6.1 Ensure that RDS instance requires all incoming connections to use SSL"
  description   = "It is recommended to enforce all incoming connections to SQL database instance to use SSL."
  sql           = query.rds_instance_ssl_enabled.sql
  documentation = file("./cis_v100/docs/cis_v100_6_1.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.1"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_2" {
  title         = "6.2 Ensure that RDS Instances are not open to the world"
  description   = "Database Server should accept connections only from trusted Network(s)/IP(s) and restrict access from the world."
  sql           = query.rds_instance_restrict_access_to_internet.sql
  documentation = file("./cis_v100/docs/cis_v100_6_2.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.2"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_3" {
  title         = "6.3 Ensure that 'Auditing' is set to 'On' for applicable database instances"
  description   = "Enable SQL auditing on all RDS except SQL Server 2012/2016/2017 and MariaDB TX."
  sql           = query.rds_instance_sql_audit_enabled.sql
  documentation = file("./cis_v100/docs/cis_v100_6_3.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.3"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_4" {
  title         = "6.4 Ensure that 'Auditing' Retention is 'greater than 6 months'"
  description   = "Database SQL Audit Retention should be configured to be greater than 90 days."
  sql           = query.rds_instance_sql_audit_retention_period_180_days.sql
  documentation = file("./cis_v100/docs/cis_v100_6_4.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.4"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_5" {
  title         = "6.5 Ensure that 'TDE' is set to 'Enabled' on for applicable database instance"
  description   = "Enable Transparent Data Encryption on every RDS instance."
  sql           = query.rds_instance_tde_enabled.sql
  documentation = file("./cis_v100/docs/cis_v100_6_5.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.5"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_7" {
  title         = "6.7 Ensure parameter 'log_connections' is set to 'ON' for PostgreSQL Database"
  description   = "Enable log_connections on PostgreSQL Servers."
  sql           = query.rds_instance_postgresql_log_connections_parameter_on.sql
  documentation = file("./cis_v100/docs/cis_v100_6_7.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.7"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_8" {
  title         = "6.8 Ensure server parameter 'log_disconnections' is set to 'ON' for PostgreSQL Database Server"
  description   = "Enable log_disconnections on PostgreSQL Servers."
  sql           = query.rds_instance_postgresql_log_disconnections_parameter_on.sql
  documentation = file("./cis_v100/docs/cis_v100_6_8.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.8"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}

control "cis_v100_6_9" {
  title         = "6.9 Ensure server parameter 'log_duration is set to 'ON' for PostgreSQL Database Server"
  description   = "Enable log_duration on PostgreSQL Servers."
  sql           = query.rds_instance_postgresql_log_duration_parameter_on.sql
  documentation = file("./cis_v100/docs/cis_v100_6_9.md")

  tags = merge(local.cis_v100_6_common_tags, {
    cis_item_id = "6.9"
    cis_level   = "1"
    cis_type    = "automated"
    service     = "AliCloud/RDS"
  })
}
