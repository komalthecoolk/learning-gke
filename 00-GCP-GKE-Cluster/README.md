# Google Cloud GKE Cluster - Terraform Configuration

This Terraform configuration deploys a production-ready Google Kubernetes Engine (GKE) cluster on Google Cloud Platform. It's based on the gcloud command specification provided in `gcloud_commands.sh`.

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

### Cluster Specifications

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| **Cluster Name** | `standard-public-cluster-1` | Name of the GKE cluster |
| **Region** | `us-central1` | GCP region for the cluster |
| **Node Locations** | `us-central1-a, b, c` | Zones for cluster nodes |
| **Number of Nodes** | `1` | Initial node count per zone |
| **Release Channel** | `REGULAR` | Automatic cluster version updates |

### Node Configuration

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| **Machine Type** | `e2-small` | VM type for cluster nodes |
| **Image Type** | `COS_CONTAINERD` | Container OS with containerd runtime |
| **Disk Type** | `pd-balanced` | Balanced persistent disk |
| **Disk Size** | `20 GB` | Storage per node |
| **Preemptible** | `true` (Spot VMs) | Use preemptible instances for cost savings |
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

All variables are defined in `variables.tf`. You can customize them by:

### Option 1: Using `terraform.tfvars`

Create a `terraform.tfvars` file:

```hcl
project_id       = "my-gcp-project"
region            = "us-west1"
cluster_name      = "my-cluster"
num_nodes         = 2
machine_type      = "e2-medium"
spot              = true
```

Then apply:
```bash
terraform apply
```

### Option 2: Using `-var` flags

```bash
terraform apply \
  -var="project_id=my-gcp-project" \
  -var="cluster_name=my-cluster" \
  -var="num_nodes=2"
```

### Option 3: Using environment variables

```bash
export TF_VAR_project_id="my-gcp-project"
export TF_VAR_cluster_name="my-cluster"
terraform apply
```

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

This will update the cluster to have 3 nodes per zone (9 total across 3 zones).

### Change Machine Type

```bash
terraform apply -var="machine_type=e2-medium"
```

Note: This applies only to new nodes; existing nodes require manual deletion.

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

- This configuration is designed for learning and CKA exam preparation
- For production use, consider adding additional security controls, backup strategies, and monitoring
- The cluster uses default networking; customize `network` and `subnetwork` variables as needed
- Spot VMs are used by default; understand the trade-offs before using in production

## Support

For issues or questions:
1. Check the [Terraform Google Provider documentation](https://registry.terraform.io/providers/hashicorp/google/latest)
2. Review [GCP documentation](https://cloud.google.com/docs)
3. Check [Kubernetes community forums](https://discuss.kubernetes.io/)
