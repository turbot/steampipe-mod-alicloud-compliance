locals {
  cis_v100_common_tags = {
    benchmark   = "cis"
    cis_version = "v1.0.0"
    plugin      = "alicloud"
  }
}

benchmark "cis_v100" {
  title         = "CIS v1.0.0"
  description   = "The CIS Alibaba Cloud Foundation Benchmark provides prescriptive guidance for configuring security options."
  #documentation = file("./cis_v100/docs/cis_overview.md")
  children = [
    benchmark.cis_v100_1,
    benchmark.cis_v100_2,
  ]
  tags = local.cis_v100_common_tags
}
