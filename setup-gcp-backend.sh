cat > ./infrastructure/backend.tf << EOF
terraform {
  backend "gcs" {
    bucket = "$USER"
    prefix = "terraform/gns3"
  }
}
EOF
