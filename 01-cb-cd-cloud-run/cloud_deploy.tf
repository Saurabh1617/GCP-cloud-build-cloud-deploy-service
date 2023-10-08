module "cloud_deploy" {
  source        = "github.com/GoogleCloudPlatform/terraform-google-cloud-deploy"
  pipeline_name = "cloud-deploy-pipeline-run"
  location      = "us-central1"
  project       = var.source_project_id
  stage_targets = [{
    target_name   = "run1"
    profiles      = ["run1"]
    target_create = true
    target_type   = "run"
    target_spec = {
      project_id     = var.source_project_id
      location       = "us-central1"
      run_service_sa = var.run_service_sa_source_project
    }
    require_approval   = false
    exe_config_sa_name = "execution-sa-run1"
    execution_config   = {}
    strategy = { standard = {
      verify = true
      }
    }
    }, {
    target_name   = "run2"
    profiles      = ["run2"]
    target_create = true
    target_type   = "run"
    target_spec = {
      project_id     = var.target_project_id
      location       = "us-central1"
      run_service_sa = var.run_service_sa_target_project
    }
    require_approval   = true
    exe_config_sa_name = "execution-sa-run2"
    execution_config   = {}
    strategy = { standard = {
      verify = true
      }
    }

    }
  ]
  trigger_sa_name   = "trigger-sa-run"
  trigger_sa_create = true
}

