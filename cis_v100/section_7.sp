locals {
  cis_v100_7_common_tags = merge(local.cis_v100_common_tags, {
    cis_section_id = "7"
  })
}

benchmark "cis_v100_7" {
  title         = "7 Kubernetes Engine"
  #documentation = file("./cis_v100/docs/cis_v100_7.md")
  children = [
    control.cis_v100_7_1,
    control.cis_v100_7_4,
    control.cis_v100_7_5,
    control.cis_v100_7_6,
    control.cis_v100_7_7,
    control.cis_v100_7_8,
    control.cis_v100_7_9,
    ]
  tags          = local.cis_v100_7_common_tags
}

control "cis_v100_7_1" {
  title         = "7.1 Ensure Log Service is set to 'Enabled' on Kubernetes Engine Clusters"
  description   = "Log Service is a complete real-time data logging service on Alibaba Cloud to support collection, shipping, search, storage and analysis for logs. It includes a user interface to call the Log Viewer and an API to management logs pragmatically. Log Service could automatically collect, process, and store your container and audit logs in a dedicated, persistent datastore. Container logs are collected from your containers. Audit logs are collected from the kube-apiserver or the deployed ingress. Events are logs about activity in the cluster, such as the deleting of Pods or Secrets."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_1.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.1"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_7_4" {
  title         = "7.4 Ensure Cluster Check triggered at least once per week for Kubernetes Clusters"
  description   = "Kubernetes Engine's cluster check feature helps you verify the system nodes and components healthy status. When you trigger the checking, the process would check on the health state of each node in your cluster and also the cluster configuration as kubelet/docker daemon/kernel and network iptables configuration, if there are fails consecutive health checks, the diagnose would report to admin for further repair."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_4.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.4"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_7_5" {
  title         = "7.5 Ensure Kubernetes web UI / Dashboard is not enabled"
  description   = "Dashboard is a web-based Kubernetes user interface. It can be used to deploy containerized applications to a Kubernetes cluster, troubleshoot your containerized application, and manage the cluster itself along with its attendant resources. You can use Dashboard to get an overview of applications running on your cluster, as well as for creating or modifying individual Kubernetes resources (such as Deployments, Jobs,DaemonSets, etc). For example, you can scale a Deployment, initiate a rolling update, restart a pod or deploy new applications using a deploy wizard."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_5.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.5"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_7_6" {
  title         = "7.6 Ensure Basic Authentication is not enabled on Kubernetes Engine"
  description   = "Basic authentication allows a user to authenticate to the cluster with a username and password and it is stored in plain text without any encryption. Disabling Basic authentication will prevent attacks like brute force. Its recommended to use either client certificate or RAM for authentication."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_6.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.6"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_7_7" {
  title         = "7.7 Ensure Network policy is enabled on Kubernetes Engine Clusters"
  description   = "A network policy is a specification of how groups of pods are allowed to communicate with each other and other network endpoints. NetworkPolicy resources use labels to select pods and define rules which specify what traffic is allowed to the selected pods. The Kubernetes Network Policy API allows the cluster administrator to specify what pods are allowed to communicate with each other."
  sql           = query.cs_kubernetes_cluster_network_policy_enabled.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_7.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.7"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_7_8" {
  title         = "7.8 Ensure ENI multiple IP mode support for Kubernetes Cluster"
  description   = "Alibaba Cloud ENI (Elastic Network Interface) has supported assign ranges of internal IP addresses as aliases to a single virtual machine's ENI network interfaces. This is useful if you have lots of services running on a VM and you want to assign each service a different IP address without quota limitation."
  sql           = query.cs_kubernetes_cluster_ipvlan_enabled.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_8.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.8"
    cis_level   = "1"
    cis_type    = "automated"
  })
}

control "cis_v100_7_9" {
  title         = "7.9 Ensure Kubernetes Cluster is created with Private cluster enabled"
  description   = "A private cluster is a cluster that makes your master inaccessible from the public internet. In a private cluster, nodes do not have public IP addresses, so your workloads run in an environment that is isolated from the internet. Nodes have addresses only in the private address space. Nodes and masters communicate with each other privately using VPC peering."
  sql           = query.manual_control.sql
  #documentation = file("./cis_v100/docs/cis_v100_7_9.md")

  tags = merge(local.cis_v100_7_common_tags, {
    cis_item_id = "7.9"
    cis_level   = "1"
    cis_type    = "automated"
  })
}