
# Service Accounts

resource "yandex_iam_service_account" "sa4bucket" {
    name      = "sa4bucket"
}
resource "yandex_resourcemanager_folder_iam_member" "storage-editor" {
    folder_id = var.folder_id
    role      = "storage.admin"
    member    = "serviceAccount:${yandex_iam_service_account.sa4bucket.id}"
    depends_on = [yandex_iam_service_account.sa4bucket]
}
resource "yandex_iam_service_account_static_access_key" "sa-sa-key" {
    service_account_id = yandex_iam_service_account.sa4bucket.id
    description        = "access key for bucket"
}

resource "yandex_iam_service_account" "sa4ig" {
    name      = "sa4ig"
}
resource "yandex_resourcemanager_folder_iam_member" "ig-editor" {
    folder_id = var.folder_id
    role      = "editor"
    member    = "serviceAccount:${yandex_iam_service_account.sa4ig.id}"
}