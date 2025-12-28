resource "google_container_cluster" "primary" {
  project                  = var.project_id
  name                     = "standard-public-cluster-1"
  location                 = "us-central1"
  initial_node_count       = 1
  release_channel {
    channel = "REGULAR"
  }
  node_config {
    machine_type    = "e2-small"
    image_type      = "COS_CONTAINERD"
    disk_type       = "pd-balanced"
    disk_size_gb    = 20
    metadata = {
      disable-legacy-endpoints = "true"
    }
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
  }
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
  }
  network    = "default"
  subnetwork = "default"
  ip_allocation_policy {
    cluster_secondary_range_name  = "gcpc-primary-cluster-1-pods"
    services_secondary_range_name = "gcpc-primary-cluster-1-services"
  }

  private_cluster_config {
    enable_private_endpoint = false
    enable_private_nodes    = false
    master_ipv4_cidr_block  = "172.16.0.0/28"
  }

  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  database_encryption {
    state    = "DECRYPTED"
    key_name = null
  }

  vertical_pod_autoscaling {
    enabled = false
  }
}


