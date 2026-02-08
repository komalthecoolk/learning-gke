# Google Cloud GKE Cluster - Terraform Configuration

This Terraform configuration deploys a production-ready Google Kubernetes Engine (GKE) cluster on Google Cloud Platform.

## Overview

This configuration creates a **regional GKE cluster** with enterprise-grade features including:
- **Spot VMs** for cost optimization
- **Managed Prometheus** for monitoring
- **Shielded nodes** for enhanced security
- **Multiple node locations** for high availability
- **Autoscaling and autorepair** for cluster management
- **IP alias networking** for efficient IP allocation

## Prerequisites

Before deploying this infrastructure, ensure you have:

1. **Terraform 1.0+**
   ```bash
   terraform version
   ```

2. **Google Cloud SDK** installed and configured
   ```bash
   gcloud auth login
   gcloud config set project <YOUR_PROJECT_ID>
   ```

3. **GKE API enabled** in your GCP project
   ```bash
   gcloud services enable container.googleapis.com
   ```

4. **Appropriate IAM permissions** (Kubernetes Engine Admin or equivalent)

## File Structure

- **versions.tf** - Terraform version requirements and provider configuration
- **main.tf** - GKE cluster resource definition
- **variables.tf** - Input variables and defaults
- **outputs.tf** - Output values for cluster information
- **gcloud_commands.sh** - Original gcloud CLI command reference

## Configuration Details

### Architecture Overview

This configuration separates cluster management from node pool management:

- **GKE Cluster** (`google_container_cluster`) - Manages the Kubernetes control plane, networking, and cluster-level settings
- **Node Pool** (`google_container_node_pool`) - Manages worker nodes, scaling, and node-level configurations

This separation provides better flexibility for managing multiple node pools and independent scaling strategies.

### Cluster Specifications

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| **Cluster Name** | `learning-gke-cluster-1` | Name of the GKE cluster |
| **Region** | `us-central1` | GCP region for the cluster |
| **Node Locations** | `us-central1-a, b, c` | Zones for cluster nodes |
| **Number of Nodes** | `1` | Initial node count per zone |
| **Release Channel** | `REGULAR` | Automatic cluster version updates |

### Node Pool Configuration

The node pool is managed as a separate resource (`google_container_node_pool`) which provides:

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| **Min Node Count** | `1` | Minimum nodes for autoscaling |
| **Max Node Count** | `3` | Maximum nodes for autoscaling |
| **Auto Repair** | `true` | Automatically repair unhealthy nodes |
| **Auto Upgrade** | `true` | Automatically upgrade node version |

#### Node Specifications

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| **Machine Type** | `e2-small` | VM type for cluster nodes |
| **Image Type** | `COS_CONTAINERD` | Container OS with containerd runtime |
| **Disk Type** | `pd-balanced` | Balanced persistent disk |
| **Disk Size** | `20 GB` | Storage per node |
| **Spot VMs** | `true` | Use preemptible instances for cost savings |
| **Max Pods per Node** | `110` | Maximum pods per node |

### Security Features

| Feature | Status |
|---------|--------|
| Shielded Node Integrity Monitoring | Enabled |
| Shielded Node Secure Boot | Disabled |
| IP Alias Networking | Enabled |
| Binary Authorization | Disabled |
| Basic Auth | Disabled |
| Intra-node Visibility | Disabled |

### Addons

- ✅ Horizontal Pod Autoscaling (HPA)
- ✅ HTTP(S) Load Balancing
- ✅ GCE Persistent Disk CSI Driver

## Usage

### 1. Initialize Terraform

```bash
cd /path/to/learning-cka/01-\ GCP\ GKE\ Cluster
terraform init
```

This downloads the required Google Cloud provider plugin and initializes the working directory.

### 2. Review the Plan

```bash
terraform plan -var="project_id=YOUR_PROJECT_ID"
```

This shows all resources that will be created. Review the output carefully before applying.

### 3. Apply the Configuration

```bash
terraform apply -var="project_id=YOUR_PROJECT_ID"
```

Type `yes` when prompted to create the cluster. This typically takes 5-10 minutes.

### 4. Configure kubectl

Once the cluster is created, configure kubectl to access it:

```bash
gcloud container clusters get-credentials $(terraform output -raw cluster_name) \
  --region $(terraform output -raw cluster_location) \
  --project YOUR_PROJECT_ID
```

Or use the terraform output directly:
```bash
eval $(terraform output -raw kubeconfig_command)
```

### 5. Verify the Cluster

```bash
kubectl get nodes
kubectl get pods -A
kubectl cluster-info
```

## Variables

All variables are defined in `variables.tf`. This section documents all available variables organized by category.

### How to Customize Variables

You can customize variables using one of three methods:

#### Option 1: Using `terraform.tfvars`

Create a `terraform.tfvars` file:

```hcl
project_id       = "my-gcp-project"
region            = "us-west1"
cluster_name      = "my-cluster"
num_nodes         = 2
machine_type      = "e2-medium"
min_node_count    = 1
max_node_count    = 3
```

Then apply:
```bash
terraform apply
```

#### Option 2: Using `-var` flags

```bash
terraform apply \
  -var="project_id=my-gcp-project" \
  -var="cluster_name=my-cluster" \
  -var="num_nodes=2" \
  -var="min_node_count=1" \
  -var="max_node_count=3"
```

#### Option 3: Using environment variables

```bash
export TF_VAR_project_id="my-gcp-project"
export TF_VAR_cluster_name="my-cluster"
export TF_VAR_num_nodes="2"
export TF_VAR_min_node_count="1"
export TF_VAR_max_node_count="3"
terraform apply
```

### Cluster Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `project_id` | string | *required* | GCP project ID |
| `region` | string | `us-central1` | GCP region for the cluster |
| `cluster_name` | string | `learning-gke-cluster-1` | Name of the GKE cluster |
| `node_locations` | list(string) | `["us-central1-a"]` | List of zones where nodes are created |
| `release_channel` | string | `REGULAR` | Release channel for cluster version updates |

### Node Pool Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `num_nodes` | number | `1` | Initial number of nodes in the node pool |
| `min_node_count` | number | `1` | Minimum nodes for autoscaling |
| `max_node_count` | number | `1` | Maximum nodes for autoscaling |

### Node Configuration Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `machine_type` | string | `e2-small` | VM type for nodes (e.g., e2-small, e2-medium, n2-standard-4) |
| `image_type` | string | `COS_CONTAINERD` | Container OS image type |
| `disk_type` | string | `pd-balanced` | Type of disk (pd-standard, pd-balanced, pd-ssd) |
| `disk_size_gb` | number | `20` | Disk size in GB |
| `default_max_pods_per_node` | number | `10` | Maximum pods per node |
| `spot` | bool | `true` | Use Spot VMs for cost optimization |
| `reservation_affinity` | string | `ANY_RESERVATION` | Reservation affinity type |

### Node Metadata and Security

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `node_metadata` | map(string) | `{"disable-legacy-endpoints": "true"}` | Metadata for nodes |
| `shielded_integrity_monitoring` | bool | `false` | Enable shielded integrity monitoring |
| `shielded_secure_boot` | bool | `false` | Enable shielded secure boot |

### Networking Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `network` | string | See defaults | VPC network self-link |
| `subnetwork` | string | See defaults | Subnetwork self-link |
| `enable_intra_node_visibility` | bool | `false` | Enable intra-node visibility |

### Logging and Monitoring Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `logging_service` | string | `logging.googleapis.com/kubernetes` | Logging service for cluster |
| `monitoring_service` | string | `monitoring.googleapis.com/kubernetes` | Monitoring service for cluster |
| `enable_managed_prometheus` | bool | `false` | Enable managed Prometheus |

### Node Management Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `enable_autoupgrade` | bool | `true` | Enable automatic node upgrades |
| `enable_autorepair` | bool | `true` | Enable automatic node repairs |
| `max_surge_upgrade` | number | `1` | Max surge during upgrade |
| `max_unavailable_upgrade` | number | `0` | Max unavailable nodes during upgrade |

### Security and Compliance Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `binary_authorization_evaluation_mode` | string | `DISABLED` | Binary authorization mode |
| `disable_workload_vulnerability_scanning` | bool | `true` | Disable workload vulnerability scanning |

## Outputs

After applying, the following information is available:

```bash
# Get all outputs
terraform output

# Get specific values
terraform output cluster_name
terraform output endpoint
terraform output kubeconfig_command
```

Available outputs:
- `cluster_name` - Name of the created cluster
- `cluster_location` - Location (region) of the cluster
- `endpoint` - Kubernetes API server endpoint
- `master_version` - Current Kubernetes master version
- `kubeconfig_command` - Command to configure kubectl
- `network` - VPC network used by cluster
- `subnetwork` - Subnetwork used by cluster
- `node_locations` - List of node zones
- `node_pool_name` - Name of the primary node pool
- `node_pool_id` - ID of the primary node pool

## Cost Optimization

This configuration uses **Spot VMs** (preemptible instances) by default, which can reduce costs by up to 90% compared to standard VMs. However, be aware that:

- Spot VMs can be terminated at any time with 25 seconds notice
- Good for non-critical workloads and development/testing
- Combine with node auto-repair for production resilience

To disable Spot VMs, set `spot = false` in variables.

## Scaling the Cluster

### Increase Node Count

```bash
terraform apply -var="num_nodes=3"
```

This updates the initial node count in the node pool.

### Scale Node Pool

For dynamic autoscaling, update the min and max node counts:

```bash
terraform apply -var="min_node_count=2" -var="max_node_count=5"
```

The cluster will automatically scale between 2 and 5 nodes based on demand.

### Change Machine Type

```bash
terraform apply -var="machine_type=e2-medium"
```

Note: This applies only to new nodes in the node pool; existing nodes require manual deletion.

## Monitoring and Logging

The cluster has Managed Prometheus and system/workload logging enabled:

```bash
# View logs in Cloud Logging
gcloud logging read "resource.type=k8s_cluster AND resource.labels.cluster_name=YOUR_CLUSTER_NAME" \
  --limit=50 --format=json
```

## Destroying the Cluster

When you no longer need the cluster:

```bash
terraform destroy -var="project_id=YOUR_PROJECT_ID"
```

Type `yes` to confirm. This will delete:
- The GKE cluster
- All workloads and data stored in the cluster
- Associated networking configurations

**Warning:** This action is irreversible. Back up any important data before destroying.

## Troubleshooting

### Error: "Insufficient regional quota"

If you get quota errors during creation:
```bash
gcloud compute regions describe us-central1
```

Consider changing the region or requesting quota increase in the Google Cloud Console.

### Cluster takes too long to create

Check the creation progress:
```bash
gcloud container clusters describe standard-public-cluster-1 --region us-central1
```

### kubectl: Unable to connect

Ensure your credentials are properly configured:
```bash
gcloud auth application-default login
kubectl cluster-info
```

## Additional Resources

- [Google Cloud GKE Documentation](https://cloud.google.com/kubernetes-engine/docs)
- [Terraform Google Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)
- [GKE Pricing](https://cloud.google.com/kubernetes-engine/pricing)
- [Kubernetes Documentation](https://kubernetes.io/docs/)

## Notes

- This configuration uses `google_container_node_pool` as a separate resource for better management and flexibility
- You can create multiple node pools with different configurations if needed
- The cluster automatically removes the default node pool when created (`remove_default_node_pool = true`)
- Auto-repair and auto-upgrade are enabled by default for production readiness
- This configuration is designed for learning and CKA exam preparation
- For production use, consider adding additional security controls, backup strategies, and monitoring
- The cluster uses default networking; customize `network` and `subnetwork` variables as needed
- Spot VMs are used by default; understand the trade-offs before using in production

## Support

For issues or questions:
1. Check the [Terraform Google Provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest)
2. Review [GCP documentation](https://cloud.google.com/docs)
3. Check [Kubernetes community forums](https://discuss.kubernetes.io/)
