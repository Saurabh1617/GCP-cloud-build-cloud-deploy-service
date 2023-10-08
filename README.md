# GCP-cloud-build-cloud-deploy-service through Terraform


This Repository will be helpful to quickstart an implementation of ci/cd using Cloud Build, Cloud Deploy, Artifact registry, Cloud Run.


## Required Api's

- cloudbuild.googleapis.com
- clouddeploy.googleapis.com
- run.googleapis.com
- artifactregistry.googleapis.com

## Disable cross project service account usage org policy

If source and target project are not same, then disable `constraints/iam.disableCrossProjectServiceAccountUsage` organization policy on the target project.

