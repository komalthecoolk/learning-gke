data "google_project" "project" {
}

resource "google_container_cluster" "primary" {
  name               = var.cluster_name
  location           = var.region
  initial_node_count = null
  remove_default_node_pool = true
  node_locations     = var.node_locations

  # Cluster version and release channel
  cluster_autoscaling {
    enabled = false
  }

  release_channel {
    channel = var.release_channel
  }
  min_master_version = "1.34.1-gke.3355002"
  node_version = "1.34.1-gke.3355002"

  # Network configuration
  network    = var.network
  subnetwork = var.subnetwork
  datapath_provider = "ADVANCED_DATAPATH"
  ip_allocation_policy {
    cluster_secondary_range_name  = ""
    services_secondary_range_name = ""
  }

  # Pod configuration
  default_max_pods_per_node = var.default_max_pods_per_node

  # Logging and monitoring
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  workload_identity_config {
  workload_pool = "${data.google_project.project.project_id}.svc.id.goog"
  }

  # Addons
  addons_config {
    horizontal_pod_autoscaling {
      disabled = false
    }
    http_load_balancing {
      disabled = false
    }
    gce_persistent_disk_csi_driver_config {
      enabled = true
    }
  }

  # Security and monitoring features
  binary_authorization {
    evaluation_mode = var.binary_authorization_evaluation_mode
  }

  # Disable basic auth
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  deletion_protection = false
}

# Default node pool resource
resource "google_container_node_pool" "node_pool_1" {
  name           = "${var.cluster_name}-node-pool-1"
  location       = var.region
  cluster        = google_container_cluster.primary.name
  node_count     = var.num_nodes
  node_locations = var.node_locations

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  node_config {
    machine_type = var.machine_type
    image_type   = var.image_type
    disk_type    = var.disk_type
    disk_size_gb = var.disk_size_gb

    metadata = var.node_metadata

    spot = true

    reservation_affinity {
      consume_reservation_type = var.reservation_affinity
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]

    shielded_instance_config {
      enable_integrity_monitoring = var.shielded_integrity_monitoring
      enable_secure_boot          = var.shielded_secure_boot
    }
  }

  depends_on = [google_container_cluster.primary]
}
