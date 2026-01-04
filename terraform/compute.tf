resource "google_compute_instance" "app" {
  count        = 2
  name         = "tfmaestro-app-${count.index}"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app.id
    access_config {}
  }

  metadata_startup_script = file("../scripts/cloud-init.sh")
}
