# GCP-cloud-build-cloud-deploy-service through Terraform


This Repository will be helpful to quickstart an implementation of ci/cd using Cloud Build, Cloud Deploy, Artifact registry, GKE or Cloud Run.

VPC, Subnets, Peerings and VPN's are created as part of provisioning private GKE clusters.

## Required Api's

- cloudbuild.googleapis.com
- clouddeploy.googleapis.com
- container.googleapis.com
- run.googleapis.com
- servicenetworking.googleapis.com
- artifactregistry.googleapis.com

## Disable cross project service account usage org policy

If source and target project are not same, then disable `constraints/iam.disableCrossProjectServiceAccountUsage` organization policy on the target project.

