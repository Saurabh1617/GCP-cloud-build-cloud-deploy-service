module "vpc" {
  source  = "terraform-google-modules/network/google"
  version = "~> 7.0"

  project_id   = var.target_project_id
  network_name = "vpc-private-gke"
  routing_mode = "GLOBAL"

  subnets = [
    {
      subnet_name           = "subnet-01"
      subnet_ip             = "10.244.252.0/22"
      subnet_region         = "asia-south1"
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
      description           = "This subnet has a description"
    }
  ]

  secondary_ranges = {
    subnet-01 = [
      {
        range_name    = "pod-range"
        ip_cidr_range = "10.0.1.0/24"
      },
      {
        range_name    = "service-range"
        ip_cidr_range = "10.0.2.0/24"
      }
    ]

  }
}
