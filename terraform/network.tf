resource "google_compute_network" "vpc" {
  name                    = "tfmaestro-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "app" {
  name          = "app-subnet"
  ip_cidr_range = "10.10.1.0/24"
  region        = var.region
  network       = google_compute_network.vpc.id
}
