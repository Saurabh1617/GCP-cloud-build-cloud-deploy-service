data "google_client_config" "default" {}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

module "gke" {
  version                    = "25.0.0"
  source                     = "terraform-google-modules/kubernetes-engine/google"
  project_id                 = var.target_project_id
  name                       = "gke-public-cluster"
  region                     = "us-central1"
  zones                      = ["us-central1-a", "us-central1-b", "us-central1-c"]
  network                    = module.vpc.network_name
  subnetwork                 = module.vpc.subnets_names[0]
  ip_range_pods              = "pod-range"
  ip_range_services          = "service-range"
  http_load_balancing        = false
  network_policy             = false
  horizontal_pod_autoscaling = true
  filestore_csi_driver       = false
  remove_default_node_pool   = true
  create_service_account     = false
  node_pools = [{
    name               = "default-node-pool" # Name for the Node Pool
    machine_type       = "e2-standard-2"     # Machine Type for Kubernetes Cluster
    node_locations     = "us-central1-c"     # Region for Node Locations. Must Match VPC region to provision
    autoscaling        = true                # Enabling Auto Scaling for the Cluster
    auto_upgrade       = true                # Enabling Auto Upgrade Functionality
    initial_node_count = 1                   # Minimum Nodes required for ASM to work
    min_count          = 1                   # Minimum Node Count
    max_count          = 3                   # Maximum Node Count for Cluster
    max_pods_per_node  = 110                 # Maximum pods per node. Default is 110
    disk_size_gb       = 10
  }, ]

}


