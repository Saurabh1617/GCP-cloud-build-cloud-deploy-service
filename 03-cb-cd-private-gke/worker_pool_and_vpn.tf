module "cloudbuild_private_pool" {
  source = "GoogleCloudPlatform/secure-cicd/google//modules/cloudbuild-private-pool"

  project_id                = var.source_project_id
  network_project_id        = var.source_project_id
  location                  = "us-central1"
  create_cloudbuild_network = true
  private_pool_vpc_name     = "private-pool-vpc"
  worker_pool_name          = "private-pool"
  machine_type              = "e2-standard-2"

  worker_address    = "10.39.0.0"
  worker_range_name = "private-pool-range"
}

locals {
  gke_config = [{
    network    = module.vpc.network_name
    project_id = var.target_project_id
    location   = "us-central1"
  }]
  gke_networks = {
    for net in local.gke_config : net.network => merge(net, local.vpn_config[net.network])
  }
  vpn_config = {
    vpc-private-gke = {
      gateway_1_asn = 65007,
      gateway_2_asn = 65008,
      bgp_range_1   = "169.254.7.0/30",
      bgp_range_2   = "169.254.8.0/30"
    }
  }
}

module "gke_cloudbuild_vpn" {
  for_each   = local.gke_networks
  depends_on = [module.gke]

  source     = "GoogleCloudPlatform/secure-cicd/google//modules/workerpool-gke-ha-vpn"
  project_id = var.source_project_id
  location   = "us-central1"

  gke_project  = each.value.project_id
  gke_network  = each.value.network
  gke_location = each.value.location
  gke_control_plane_cidrs = {
    "172.16.0.32/28" = "GKE Cluster CIDR"
  }

  workerpool_network = module.cloudbuild_private_pool.workerpool_network
  workerpool_range   = module.cloudbuild_private_pool.workerpool_range
  gateway_1_asn      = each.value.gateway_1_asn
  gateway_2_asn      = each.value.gateway_2_asn
  bgp_range_1        = each.value.bgp_range_1
  bgp_range_2        = each.value.bgp_range_2

  vpn_router_name_prefix = "pc-"
}
