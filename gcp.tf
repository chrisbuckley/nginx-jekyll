terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version => "5.6.0"
    }
  }
}

# JSON key of service account
# performing the actions, full path
variable "google_credentials" {
  type = string
}

# Project we're deploying to
variable "google_project" {
  type = string
}

# GCP region we're deploying to
variable "google_region" {
  type = string
  default = "us-east4"
}

# Name of instance
variable "google_instance_name" {
  type = string
  default = "cbuckley-vm"
}

# Size of instance
variable "google_instance_machine_type" {
  type = string
  default = "f1-micro"
}

# OS image to install
variable "google_instance_image" {
  type = string
  default = "debian-cloud/debian-10"
}

provider "google" {
  credentials = file(var.google_credentials)
  project     = var.google_project
  region      = var.google_region
}

resource "google_compute_instance" "nginx_instance" {
  name         = var.google_instance_name
  machine_type = var.google_instance_machine_type

  boot_disk {
    initialize_params {
      image = var.google_instance_image
    }
  }

  network_interface {
    network = "default"
  }

  metadata_startup_script = "sudo apt-get update && sudo apt-get install -y nginx && sudo service nginx start"
}
