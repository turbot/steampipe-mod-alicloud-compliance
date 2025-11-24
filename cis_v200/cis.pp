locals {
  cis_v200_common_tags = merge(local.alicloud_compliance_common_tags, {
    cis         = "true"
    cis_version = "v2.0.0"
  })
}

benchmark "cis_v200" {
  title         = "CIS v2.0.0"
  description   = "The CIS Alibaba Cloud Foundation Benchmark covers foundational elements of Alibaba Cloud. The recommendations detailed here provides prescriptive guidance for configuring security options for a subset of Alibaba Cloud services with an emphasis on foundational, testable, and architecture agnostic settings."
  documentation = file("./cis_v200/docs/cis_overview.md")
  children = [
    benchmark.cis_v200_1,
    benchmark.cis_v200_2,
    benchmark.cis_v200_3,
    benchmark.cis_v200_4,
    benchmark.cis_v200_5,
    benchmark.cis_v200_6,
    benchmark.cis_v200_7,
    benchmark.cis_v200_8
  ]

  tags = merge(local.cis_v200_common_tags, {
    type = "Benchmark"
  })
}
