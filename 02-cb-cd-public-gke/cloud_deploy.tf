module "cloud_deploy" {
  source        = "github.com/GoogleCloudPlatform/terraform-google-cloud-deploy"
  pipeline_name = "cloud-deploy-pipeline-pub-gke"
  location      = "us-central1"
  project       = var.source_project_id
  stage_targets = [{
    target_name   = "ns-pub"
    profiles      = ["ns"]
    target_create = true
    target_type   = "gke"
    target_spec = {
      project_id       = var.target_project_id
      location         = module.gke.location
      gke_cluster_name = module.gke.name
      gke_cluster_sa   = var.gke_cluster_sa
    }
    require_approval   = false
    exe_config_sa_name = "execution-sa-ns-pub"
    execution_config   = {}
    strategy           = {}
    }, {
    target_name   = "dev-pub"
    profiles      = ["dev"]
    target_create = true
    target_type   = "gke"
    target_spec = {
      project_id       = var.target_project_id
      location         = module.gke.location
      gke_cluster_name = module.gke.name
      gke_cluster_sa   = var.gke_cluster_sa
    }
    require_approval   = true
    exe_config_sa_name = "execution-sa-dev-pub"
    execution_config   = {}
    strategy = { standard = {
      verify = true
      }
    }
    }, {
    target_name   = "qa-pub"
    profiles      = ["qa"]
    target_create = true
    target_type   = "gke"
    target_spec = {
      project_id       = var.target_project_id
      location         = module.gke.location
      gke_cluster_name = module.gke.name
      gke_cluster_sa   = var.gke_cluster_sa
    }
    require_approval   = true
    exe_config_sa_name = "execution-sa-qa-pub"
    execution_config   = {}
    strategy = { standard = {
      verify = true
      }
    }
    }, {
    target_name   = "prod-pub"
    profiles      = ["prod"]
    target_create = true
    target_type   = "gke"
    target_spec = {
      project_id       = var.target_project_id
      location         = module.gke.location
      gke_cluster_name = module.gke.name
      gke_cluster_sa   = var.gke_cluster_sa
    }
    require_approval   = true
    exe_config_sa_name = "execution-sa-prod-pub"
    execution_config   = {}
    strategy = { standard = {
      verify = true
      }
    }
  }]
  trigger_sa_name   = "trigger-sa-pub"
  trigger_sa_create = true
}

