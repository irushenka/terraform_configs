resource "yandex_container_registry" "test-reg" {
  name = "test-registry"
  folder_id = "${var.yandex_folder_id}"
  labels = {
    my-label = "my-label-value"
  }
}