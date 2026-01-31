terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "7.17.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials)
  project     = var.project
  region      = var.region
}

# Taken from https://registry.terraform.io/providers/hashicorp/google/latest/docs

resource "google_storage_bucket" "demo-bucket" {
  name          = var.gcs_bucket_name
  location      = var.location
  force_destroy = true

  # lifecycle_rule {
  #   condition {
  #     age = 3
  #   }
  #   action {
  #     type = "Delete"
  #   }
  # }

  lifecycle_rule {
    condition {
      age = 1
    }
    action {
      type = "AbortIncompleteMultipartUpload"
    }
  }
}

# The above was taken from "Example Usage - Life cycle settings for storage bucket objects" at:
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket

resource "google_bigquery_dataset" "demo_dataset" {
  dataset_id = var.bq_dataset_name
  location   = var.location
}

# Check the following links:
# (Maybe not this one) https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/bigquery_dataset
# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
# https://registry.terraform.io/providers/hashicorp/google/6.3.0/docs/resources/bigquery_dataset