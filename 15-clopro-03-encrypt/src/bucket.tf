# Object Storage + Bucket + Secret

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa4bucket.id
  description        = "static access key for object storage"
}

resource "yandex_kms_symmetric_key" "key-a" {
  name              = "symmetric-key"
  description       = "safe my bucket"
  default_algorithm = "AES_256"
  rotation_period   = "1000h"
}


// Use keys to create bucket
resource "yandex_storage_bucket" "pictures-bucket" {
  depends_on = [yandex_iam_service_account.sa4bucket]
  access_key = yandex_iam_service_account_static_access_key.sa-sa-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-sa-key.secret_key
  bucket     = "pictures-bucket"
  acl        = "public-read"
  max_size   = 1048576

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = yandex_kms_symmetric_key.key-a.id
        sse_algorithm     = "aws:kms" //required field
      }
    }
  }
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

