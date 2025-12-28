# Google Kubernetes Engine (GKE) Cluster Deployment with Terraform

This folder contains Terraform configuration to deploy a Google Kubernetes Engine (GKE) cluster in Google Cloud Platform (GCP).

## Overview

This Terraform configuration provisions a GKE cluster based on the specifications derived from the `gcloud_commands.sh` script. It sets up a public GKE cluster with a single node pool, `e2-small` machine types, and basic networking.

## Files

*   `main.tf`: Defines the `google_container_cluster` resource, which is the core of the GKE cluster configuration.
*   `variables.tf`: Contains input variables for customizing the project ID, region, cluster name, node machine type, disk size, and node locations.
*   `outputs.tf`: Exports important information about the deployed GKE cluster, such as its name, ID, and endpoint.
*   `providers.tf`: Configures the Google Cloud provider for Terraform, specifying the required provider version and linking to the project and region variables.
*   `gcloud_commands.sh`: The original `gcloud` command used as a reference to create this Terraform configuration.

## Prerequisites

Before deploying this Terraform configuration, ensure you have the following:

1.  **Google Cloud Platform (GCP) Account**: An active GCP account with billing enabled.
2.  **GCP Project**: A GCP project where the GKE cluster will be deployed.
3.  **`gcloud` CLI**: The Google Cloud SDK (`gcloud` command-line tool) installed and authenticated. Ensure you have selected the correct project:
    ```bash
    gcloud auth login
    gcloud config set project MY_PROJECT_ID
    ```
4.  **Terraform CLI**: Terraform installed (version 1.0 or higher).

## Configuration

You can customize the deployment by modifying the `variables.tf` file or by passing variables directly during Terraform execution.

*   `project_id`: Your GCP project ID.
*   `region`: The GCP region where the GKE cluster will be created (e.g., `us-central1`).
*   `cluster_name`: The desired name for your GKE cluster.
*   `node_machine_type`: The machine type for the nodes in the cluster's node pool (e.g., `e2-small`).
*   `node_disk_size_gb`: The disk size in GB for the nodes.
*   `node_locations`: A list of zones for your node locations.

## Deployment Instructions

Follow these steps to deploy the GKE cluster using Terraform:

1.  **Initialize Terraform**: Navigate to this directory in your terminal and initialize Terraform. This command downloads the necessary provider plugins.
    ```bash
    terraform init
    ```

2.  **Review the Plan**: Generate an execution plan to see what actions Terraform will perform. Review this plan carefully to ensure it aligns with your expectations.
    ```bash
    terraform plan
    ```

3.  **Apply the Configuration**: Apply the Terraform configuration to deploy the GKE cluster. Type `yes` when prompted to confirm the deployment.
    ```bash
    terraform apply
    ```

## Outputs

After a successful deployment, Terraform will output the following information about your GKE cluster:

*   `cluster_name`: The name of the deployed GKE cluster.
*   `cluster_id`: The unique ID of the GKE cluster.
*   `cluster_endpoint`: The public IP address of the GKE cluster's control plane.

## Cleanup

To destroy all resources created by this Terraform configuration, run the following command. Type `yes` when prompted to confirm the destruction.

```bash
terraform destroy
```
