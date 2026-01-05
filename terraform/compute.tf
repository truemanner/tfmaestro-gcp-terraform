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

  metadata_startup_script = templatefile("../scripts/cloud-init.sh", {
    db_user     = var.db_user
    db_password = var.db_password
  })
}

resource "google_compute_instance" "db" {
  name         = "tfmaestro-db"
  machine_type = "e2-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-12"
    }
  }

  network_interface {
    subnetwork = google_compute_subnetwork.app.id
    # brak zewnętrznego IP – baza dostępna tylko z sieci VPC
  }

  metadata_startup_script = templatefile("../scripts/db-cloud-init.sh", {
    db_user     = var.db_user
    db_password = var.db_password
  })
}
