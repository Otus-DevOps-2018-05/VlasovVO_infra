provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "app" {
  name         = "reddit-app${count.index}"
  machine_type = "g1-small"
  zone =  "${var.zone}"
  count = "${var.count}"
  # zone = "europe-west1-b"
  # определение загрузочного диска
  boot_disk {
    initialize_params {
      image = "${var.disk_image}"
    }
  }

  tags = ["reddit-app"]

  metadata {
    ssh-keys = "appuser:${file(var.public_key_path)}"
  }

  # определение сетевого интерфейса
  network_interface {
    # сеть, к которой присоединить данный интерфейс
    network = "default"

    # использовать ephemeral IP для доступа из Интернет
    access_config {}
  }

  connection {
    type        = "ssh"
    user        = "appuser"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}

resource "google_compute_firewall" "firewall_puma" {
  name = "allow-puma-default"

  # Название сети, в которой действует правило
  network = "default"

  # Какой доступ разрешить
  allow {
    protocol = "tcp"
    ports    = ["9292"]
  }

  # Каким адресам разрешаем доступ
  source_ranges = ["0.0.0.0/0"]

  # Правило применимо для инстансов с тегом …
  target_tags = ["reddit-app"]
}

resource "google_compute_project_metadata_item" "add_many_user" {
  key = "ssh-keys"
  value = "appuser1:${file("~/.ssh/appuser.pub")}appuser2:${file("~/.ssh/appuser.pub")}appuser3:${file("~/.ssh/appuser.pub")}appuser4:${file("~/.ssh/appuser.pub")}"
}
