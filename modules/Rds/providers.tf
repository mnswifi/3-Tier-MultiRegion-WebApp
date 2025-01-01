# Define the provider region for the backup KMS module.
provider "aws" {
  region = var.backup_region
  alias  = "backup_provider"
}
