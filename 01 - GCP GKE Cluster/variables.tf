variable "project_id" {
  description = "The GCP project ID."
  type        = string
  default     = "mylearning-354010"
}

variable "region" {
  description = "The GCP region for the cluster."
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the GKE cluster."
  type        = string
  default     = "standard-public-cluster-1"
}

variable "node_machine_type" {
  description = "The machine type for the GKE nodes."
  type        = string
  default     = "e2-small"
}

variable "node_disk_size_gb" {
  description = "The disk size in GB for the GKE nodes."
  type        = number
  default     = 20
}

variable "node_locations" {
  description = "The list of zones in which the cluster's nodes should be located."
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b", "us-central1-c"]
}
