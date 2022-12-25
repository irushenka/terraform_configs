resource "yandex_iam_service_account" "irushenka" {
  name        = "irushenka"
  description = "service account to manage cluster"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
 folder_id          = "${var.yandex_folder_id}"
 role      = "editor"
 members   = [
   "serviceAccount:${yandex_iam_service_account.irushenka.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-puller" {
 folder_id          = "${var.yandex_folder_id}"
 role      = "container-registry.images.puller"
 members   = [
   "serviceAccount:${yandex_iam_service_account.irushenka.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_binding" "images-pusher" {
 folder_id          = "${var.yandex_folder_id}"
 role      = "container-registry.images.pusher"
 members   = [
   "serviceAccount:${yandex_iam_service_account.irushenka.id}"
 ]
}

resource "yandex_resourcemanager_folder_iam_member" "admin" {
  folder_id = "${var.yandex_folder_id}"
  role      = "kms.keys.encrypterDecrypter"
  member    = "serviceAccount:${yandex_iam_service_account.irushenka.id}"
}

resource "yandex_kms_symmetric_key" "key-default" {
  folder_id          = "${var.yandex_folder_id}"
  name              = "key-default"
  description       = "key to encrypt bucket files"
  default_algorithm = "AES_128"
  rotation_period   = "8760h"
  lifecycle {
    prevent_destroy = false
  }
}
