resource "yandex_vpc_network" "network-default" {
  name = "network-default"
}

resource "yandex_vpc_subnet" "public1" {
  name           = "public1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network-default.id
  v4_cidr_blocks = ["192.168.30.0/24"]
}

resource "yandex_vpc_subnet" "public2" {
  name           = "public2"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.network-default.id
  v4_cidr_blocks = ["192.168.40.0/24"]
}
