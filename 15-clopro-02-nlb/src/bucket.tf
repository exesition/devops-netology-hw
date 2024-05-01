
# Object Storage + Bucket

resource "yandex_storage_bucket" "pictures-bucket" {
  depends_on = [yandex_iam_service_account.sa4bucket]
  access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
  bucket     = "pictures-bucket"
  acl        = "public-read"
  max_size   = 1048576
}
resource "yandex_storage_object" "pictures" {
  depends_on = [yandex_iam_service_account.sa4bucket]
  access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
  bucket     = yandex_storage_bucket.pictures-bucket.bucket
  key        = "bitoc.png"
  source     = "../bitoc.png"
  acl        = "public-read"
}
