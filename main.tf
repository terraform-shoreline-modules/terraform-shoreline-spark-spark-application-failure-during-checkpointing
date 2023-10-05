terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "spark_application_failure_during_checkpointing" {
  source    = "./modules/spark_application_failure_during_checkpointing"

  providers = {
    shoreline = shoreline
  }
}