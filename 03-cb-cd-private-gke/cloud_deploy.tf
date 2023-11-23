module "cloud_deploy" {
  source        = "github.com/GoogleCloudPlatform/terraform-google-cloud-deploy"
  pipeline_name = "cloud-deploy-pipeline-pri-gke"
  location      = "europe-west2"
  project       = var.source_project_id
  stage_targets = [{
    target_name   = "ns-pri"
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
    exe_config_sa_name = "execution-sa-ns-pri"
    execution_config = {
      worker_pool = module.cloudbuild_private_pool.workerpool_id
    }
    strategy = {}
    }, {
    target_name   = "dev-pri"
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
    exe_config_sa_name = "execution-sa-dev-pri"
    execution_config = {
      worker_pool = module.cloudbuild_private_pool.workerpool_id
    }
    strategy = { standard = {
      verify = true
      }
    }
    }, {
    target_name   = "qa-pri"
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
    exe_config_sa_name = "execution-sa-qa-pri"
    execution_config = {
      worker_pool = module.cloudbuild_private_pool.workerpool_id
    }
    strategy = { standard = {
      verify = true
      }
    }
    }, {
    target_name   = "prod-pri"
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
    exe_config_sa_name = "execution-sa-prod-pri"
    execution_config = {
      worker_pool = module.cloudbuild_private_pool.workerpool_id
    }
    strategy = { standard = {
      verify = true
      }
    }
  }]
  trigger_sa_name   = "trigger-sa-pri"
  trigger_sa_create = true
}

