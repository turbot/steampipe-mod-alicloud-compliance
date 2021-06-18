mod "alicloud_compliance" {
  # hub metadata
  title         = "Alibaba Cloud Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Alibaba Cloud accounts using Steampipe."
  color         = "#FF6600"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/alicloud-compliance.svg"
  categories    = ["alicloud", "cis", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Steampipe Mod for Alibaba Cloud Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Alibaba Cloud accounts using Steampipe."
    image       = "/images/mods/turbot/alicloud-compliance-social-graphic.png"
  }
}
