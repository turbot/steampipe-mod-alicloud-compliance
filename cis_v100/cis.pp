locals {
  cis_v100_common_tags = merge(local.alicloud_compliance_common_tags, {
    cis         = "true"
    cis_version = "v1.0.0"
  })
}

benchmark "cis_v100" {
  title         = "Alibaba Cloud CIS v1.0.0"
  description   = "The CIS Alibaba Cloud Foundation Benchmark covers foundational elements of Alibaba Cloud. The recommendations detailed here provides prescriptive guidance for configuring security options for a subset of Alibaba Cloud services with an emphasis on foundational, testable,and architecture agnostic settings."
  documentation = file("./cis_v100/docs/cis_overview.md")
  children = [
    benchmark.cis_v100_1,
    benchmark.cis_v100_2,
    benchmark.cis_v100_3,
    benchmark.cis_v100_4,
    benchmark.cis_v100_5,
    benchmark.cis_v100_6,
    benchmark.cis_v100_7,
    benchmark.cis_v100_8,
  ]

  tags = merge(local.cis_v100_common_tags, {
    type = "Benchmark"
  })
}
