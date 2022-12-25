resource "yandex_compute_instance_group" "ig-fixed-default" {
  name               = "ig-fixed-default"
  folder_id          = "${var.yandex_folder_id}"
  service_account_id = "${yandex_iam_service_account.irushenka.id}"
  depends_on          = [yandex_resourcemanager_folder_iam_binding.editor]
  instance_template {
    platform_id = "standard-v3"
    resources {
      memory = 10
      cores  = 2
    }

    boot_disk {
      mode = "READ_WRITE"
      initialize_params {
        image_id = "fd8v0s6adqu3ui3rsuap"
        size = 15
      }
    }

    network_interface {
      network_id = yandex_vpc_network.network-default.id
      subnet_ids = [yandex_vpc_subnet.public1.id]
      nat = true
    }

    metadata = {
      user-data = "${file("${var.meta_ssh_file_path}")}"
    }
  }

  scale_policy {
    fixed_scale {
      size = 3
    }
  }

  allocation_policy {
    zones = ["ru-central1-a"]
  }

  deploy_policy {
    max_unavailable = 1
    max_expansion = 0
  }
  
  load_balancer {
    target_group_name        = "tg-default"
    target_group_description = "load balancer target group"
  }
}

data "yandex_lb_target_group" "tg-default" {
  name = yandex_compute_instance_group.ig-fixed-default.load_balancer[0].target_group_name
}

resource "yandex_lb_network_load_balancer" "network-lb-default" {
  name = "network-lb-default"
  depends_on          = [yandex_compute_instance_group.ig-fixed-default]
  
  listener {
    name = "network-lb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  
  attached_target_group {
    target_group_id = data.yandex_lb_target_group.tg-default.id
   
   healthcheck {
      name = "tg-default-healthcheck"
        http_options {
          port = 80
          path = "/index.html"
        }
    } 
  }
}

