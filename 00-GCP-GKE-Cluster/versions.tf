terraform {
  required_version = ">= 1.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }

  backend "gcs" {
    bucket = "kk-terraform-state-bucket"
    prefix = "learning-gke/01-GCP-GKE-Cluster"
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
