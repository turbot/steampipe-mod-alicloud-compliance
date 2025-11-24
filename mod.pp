mod "alicloud_compliance" {
  # Hub metadata
  title         = "Alibaba Cloud Compliance"
  description   = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Alibaba Cloud accounts using Powerpipe and Steampipe."
  color         = "#FF6600"
  documentation = file("./docs/index.md")
  icon          = "/images/mods/turbot/alicloud-compliance.svg"
  categories    = ["alicloud", "cis", "compliance", "public cloud", "security"]

  opengraph {
    title       = "Powerpipe Mod for Alibaba Cloud Compliance"
    description = "Run individual configuration, compliance and security controls or full compliance benchmarks for CIS across all of your Alibaba Cloud accounts using Powerpipe and Steampipe."
    image       = "/images/mods/turbot/alicloud-compliance-social-graphic.png"
  }

  require {
    plugin "alicloud" {
      min_version = "1.5.0"
    }
  }
}
