variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "standard-public-cluster-1"
}

variable "num_nodes" {
  description = "Number of nodes in the cluster"
  type        = number
  default     = 1
}

variable "node_locations" {
  description = "List of zones where cluster nodes should be created"
  type        = list(string)
  default     = ["us-central1-a"]
}

variable "release_channel" {
  description = "Release channel for cluster version updates"
  type        = string
  default     = "REGULAR"
}

variable "machine_type" {
  description = "Machine type for cluster nodes"
  type        = string
  default     = "e2-small"
}

variable "image_type" {
  description = "Image type for nodes"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "disk_type" {
  description = "Type of disk attached to nodes"
  type        = string
  default     = "pd-balanced"
}

variable "disk_size_gb" {
  description = "Size of the disk attached to nodes in GB"
  type        = number
  default     = 20
}

variable "node_metadata" {
  description = "Metadata for nodes"
  type        = map(string)
  default = {
    disable-legacy-endpoints = "true"
  }
}

variable "reservation_affinity" {
  description = "Type of reservation affinity"
  type        = string
  default     = "ANY_RESERVATION"
}

variable "spot" {
  description = "Enable spot VMs for the node pool"
  type        = bool
  default     = true
}

variable "default_max_pods_per_node" {
  description = "Default maximum number of pods per node"
  type        = number
  default     = 110
}

variable "enable_intra_node_visibility" {
  description = "Enable intra-node visibility"
  type        = bool
  default     = false
}

variable "network" {
  description = "The name or self_link of the Google Compute Engine network"
  type        = string
  default     = "projects/mylearning-354010/global/networks/some-default-vpc"
}

variable "subnetwork" {
  description = "The name or self_link of the Google Compute Engine subnetwork"
  type        = string
  default     = "projects/mylearning-354010/regions/us-central1/subnetworks/some-default-vpc"
}

variable "logging_service" {
  description = "Logging service for the cluster"
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "Monitoring service for the cluster"
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "enable_autoupgrade" {
  description = "Enable autoupgrade for nodes"
  type        = bool
  default     = true
}

variable "enable_autorepair" {
  description = "Enable autorepair for nodes"
  type        = bool
  default     = true
}

variable "max_surge_upgrade" {
  description = "Max surge during upgrade"
  type        = number
  default     = 1
}

variable "max_unavailable_upgrade" {
  description = "Max unavailable nodes during upgrade"
  type        = number
  default     = 0
}

variable "disable_workload_vulnerability_scanning" {
  description = "Disable workload vulnerability scanning"
  type        = bool
  default     = true
}

variable "binary_authorization_evaluation_mode" {
  description = "Binary authorization evaluation mode"
  type        = string
  default     = "DISABLED"
}

variable "enable_managed_prometheus" {
  description = "Enable managed Prometheus"
  type        = bool
  default     = true
}

variable "shielded_integrity_monitoring" {
  description = "Enable shielded integrity monitoring"
  type        = bool
  default     = true
}

variable "shielded_secure_boot" {
  description = "Enable shielded secure boot"
  type        = bool
  default     = false
}
