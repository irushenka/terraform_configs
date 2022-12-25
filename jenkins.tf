resource "yandex_compute_instance" "jenkins" {
  name                      = "jenkins"
  zone                      = "ru-central1-a"
  hostname                  = "jenkins.netology.cloud"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 12
  }

  boot_disk {
    initialize_params {
      image_id    = "fd8n2l6igots3v1qfptm"
      size = 15
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.public1.id
    nat       = true
  }

  metadata = {
    user-data = "${file("${var.meta_ssh_file_path}")}"
  }
}