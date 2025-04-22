resource "azapi_resource" "big_data_pools" {
  for_each = var.big_data_pools

  type = "Microsoft.Synapse/workspaces/bigDataPools@2021-06-01"
  body = {
    properties = {
      autoPause = each.value.auto_pause != null ? {
        delayInMinutes = each.value.auto_pause.delay_in_minutes
        enabled        = each.value.auto_pause.enabled
      } : null
      autoScale = each.value.auto_scale != null ? {
        enabled      = each.value.auto_scale.enabled
        maxNodeCount = each.value.auto_scale.max_node_count
        minNodeCount = each.value.auto_scale.min_node_count
      } : null
      cacheSize             = each.value.cache_size
      customLibraries       = each.value.custom_libraries
      defaultSparkLogFolder = each.value.default_spark_log_folder
      dynamicExecutorAllocation = each.value.dynamic_executor_allocation != null ? {
        enabled      = each.value.dynamic_executor_allocation.enabled
        maxExecutors = each.value.dynamic_executor_allocation.max_executors
        minExecutors = each.value.dynamic_executor_allocation.min_executors
      } : null
      isAutotuneEnabled         = each.value.is_autotune_enabled
      isComputeIsolationEnabled = each.value.is_compute_isolation_enabled
      libraryRequirements = each.value.library_requirements != null ? {
        content  = each.value.library_requirements.content
        filename = each.value.library_requirements.filename
      } : null
      nodeCount                   = each.value.auto_scale.enabled ? 0 : each.value.node_count
      nodeSize                    = each.value.node_size
      nodeSizeFamily              = each.value.node_size_family
      sessionLevelPackagesEnabled = each.value.session_level_packages_enabled
      sparkConfigProperties = each.value.spark_config_properties != null ? {
        content  = each.value.spark_config_properties.content
        filename = each.value.spark_config_properties.filename
      } : null
      sparkEventsFolder = each.value.spark_events_folder
      sparkVersion      = each.value.spark_version
    }
  }
  location  = each.value.location != null ? each.value.location : var.location
  name      = each.value.name
  parent_id = azapi_resource.this.id
  tags = merge(
    azapi_resource.this.tags,
    each.value.tags
  )
}
