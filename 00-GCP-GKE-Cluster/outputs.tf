output "cluster_name" {
  description = "Name of the GKE cluster"
  value       = google_container_cluster.primary.name
}

output "cluster_location" {
  description = "Location of the cluster"
  value       = google_container_cluster.primary.location
}

output "endpoint" {
  description = "Endpoint for the GKE cluster master"
  value       = google_container_cluster.primary.endpoint
}

output "master_version" {
  description = "Current master version"
  value       = google_container_cluster.primary.master_version
}

output "kubeconfig_command" {
  description = "Command to configure kubectl"
  value       = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --region ${var.region} --project ${var.project_id}"
}

output "network" {
  description = "Network used by the cluster"
  value       = google_container_cluster.primary.network
}

output "subnetwork" {
  description = "Subnetwork used by the cluster"
  value       = google_container_cluster.primary.subnetwork
}

output "node_locations" {
  description = "Node locations in the cluster"
  value       = google_container_cluster.primary.node_locations
}
