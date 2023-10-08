resource "google_artifact_registry_repository" "my-repo" {
  location      = "us-central1"
  project       = var.source_project_id
  repository_id = "my-repository"
  description   = "docker repository"
  format        = "DOCKER"
}

resource "google_cloudbuild_trigger" "manual-trigger" {
  name    = "manual-build"
  project = var.source_project_id

  source_to_build {
    uri       = var.repo_url
    ref       = "refs/heads/main"
    repo_type = "GITHUB"
  }

  git_file_source {
    path      = "03-ci-cd-cloud-run/apps/cloudbuild.yaml"
    uri       = var.repo_url
    revision  = "refs/heads/main"
    repo_type = "GITHUB"
  }

  service_account = "projects/${var.source_project_id}/serviceAccounts/${module.cloud_deploy.trigger_sa[0]}"

}

resource "google_project_iam_member" "trigger_sa_admin" {
  project = var.source_project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${module.cloud_deploy.trigger_sa[0]}"

}
