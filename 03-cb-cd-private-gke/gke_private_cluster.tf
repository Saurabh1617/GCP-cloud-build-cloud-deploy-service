data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  source                     = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version         	     = "27.0.0"	
  project_id                 = var.target_project_id
  name                       = "gke-private-cluster"
  region                     = "me-central1"
  zones                      = ["me-central1-a", "me-central1-b", "me-central1-c"]
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = "pod-range"
  ip_range_services          = "service-range"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  enable_private_endpoint    = true
  enable_private_nodes       = true
  filestore_csi_driver       = false
  remove_default_node_pool   = true
  create_service_account     = false
  master_ipv4_cidr_block     = "172.16.0.32/28"
  master_authorized_networks = [{
    cidr_block   = module.cloudbuild_private_pool.workerpool_range # Change this to be the IP from which Kubernetes Can be accessed outside of GCP Network
    display_name = "privatepool"
  }]

  node_pools = [{
    name               = "my-node-pool" # Name for the Node Pool
    machine_type       = "e2-standard-4"     # Machine Type for Kubernetes Cluster
    node_locations     = "me-central1-c"     # Region for Node Locations. Must Match VPC region to provision
    autoscaling        = true                # Enabling Auto Scaling for the Cluster
    auto_upgrade       = true                # Enabling Auto Upgrade Functionality
    initial_node_count = 1                   # Minimum Nodes required for ASM to work
    min_count          = 0                   # Minimum Node Count
    max_count          = 1                   # Maximum Node Count for Cluster
    max_pods_per_node  = 110                 # Maximum pods per node. Default is 110
  }, ]

}

resource "google_compute_network_peering_routes_config" "service_networking_peering_config" {
  project = var.target_project_id
  peering = module.gke.peering_name
  network = module.vpc.network_name

  export_custom_routes = true
  import_custom_routes = true

}
