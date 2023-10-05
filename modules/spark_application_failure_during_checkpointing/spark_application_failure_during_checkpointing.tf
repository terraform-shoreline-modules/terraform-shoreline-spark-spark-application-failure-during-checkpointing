resource "shoreline_notebook" "spark_application_failure_during_checkpointing" {
  name       = "spark_application_failure_during_checkpointing"
  data       = file("${path.module}/data/spark_application_failure_during_checkpointing.json")
  depends_on = [shoreline_action.invoke_memory_allocation,shoreline_action.invoke_update_spark_resources]
}

resource "shoreline_file" "memory_allocation" {
  name             = "memory_allocation"
  input_file       = "${path.module}/data/memory_allocation.sh"
  md5              = filemd5("${path.module}/data/memory_allocation.sh")
  description      = "Insufficient memory allocation for the Spark application, leading to checkpointing failures."
  destination_path = "/agent/scripts/memory_allocation.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_spark_resources" {
  name             = "update_spark_resources"
  input_file       = "${path.module}/data/update_spark_resources.sh"
  md5              = filemd5("${path.module}/data/update_spark_resources.sh")
  description      = "Increase the resources allocated to the Spark application to mitigate potential resource contention issues."
  destination_path = "/agent/scripts/update_spark_resources.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_memory_allocation" {
  name        = "invoke_memory_allocation"
  description = "Insufficient memory allocation for the Spark application, leading to checkpointing failures."
  command     = "`chmod +x /agent/scripts/memory_allocation.sh && /agent/scripts/memory_allocation.sh`"
  params      = ["SPARK_APPLICATION_NAME","PATH_TO_SPARK_APP","DRIVER_MEMORY","EXECUTOR_MEMORY"]
  file_deps   = ["memory_allocation"]
  enabled     = true
  depends_on  = [shoreline_file.memory_allocation]
}

resource "shoreline_action" "invoke_update_spark_resources" {
  name        = "invoke_update_spark_resources"
  description = "Increase the resources allocated to the Spark application to mitigate potential resource contention issues."
  command     = "`chmod +x /agent/scripts/update_spark_resources.sh && /agent/scripts/update_spark_resources.sh`"
  params      = ["SPARK_APPLICATION_NAME","SPARK_APPLICATION_CONFIG_FILE","AMOUNT_OF_RESOURCES_TO_ALLOCATE"]
  file_deps   = ["update_spark_resources"]
  enabled     = true
  depends_on  = [shoreline_file.update_spark_resources]
}

