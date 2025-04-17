
variable "big_data_pools" {
  type = map(object({
    name             = string
    node_size        = string
    node_size_family = string
    spark_version    = string
    location         = optional(string, null)
    auto_pause = optional(object({
      delay_in_minutes = optional(number)
      enabled          = optional(bool, true)
    }))
    auto_scale = optional(object({
      enabled        = bool
      max_node_count = optional(number, 1)
      min_node_count = optional(number, 3)
    }))
    cache_size = optional(string, null)
    custom_libraries = optional(list(object({
      name    = string
      version = string
      uri     = string
    })), [])
    default_spark_log_folder = optional(string, null)
    spark_events_folder      = optional(string, null)
    dynamic_executor_allocation = optional(object({
      enabled       = bool
      max_executors = optional(number)
      min_executors = optional(number)
    }))
    is_autotune_enabled          = optional(bool, false)
    is_compute_isolation_enabled = optional(bool, false)
    library_requirements = optional(object({
      content  = string
      filename = string
    }))
    node_count                     = optional(number, 0)
    session_level_packages_enabled = optional(bool, false)
    spark_config_properties = optional(object({
      content  = string
      filename = string
    }))
    tags = optional(map(string), null)
  }))
  default     = {}
  description = <<DESCRIPTION
A map of Spark pools to create on the Synapse workspace.
- `name` - The name of the Spark pool.
- `node_size` - The size of the nodes in the Spark pool.
- `node_size_family` - The family of the nodes in the Spark pool.
- `spark_version` - The version of Spark to use in the Spark pool.
- `location` - (Optional) The location of the Spark pool. Defaults to the location of the Synapse workspace.
- `auto_pause` - (Optional) A map of auto pause settings for the Spark pool. The following properties can be specified:
  - `delay_in_minutes` - The delay in minutes before the Spark pool is paused.
  - `enabled` - Whether to enable auto pause. Defaults to true.
- `auto_scale` - (Optional) A map of auto scale settings for the Spark pool. The following properties can be specified:
  - `enabled` - Whether to enable auto scale. Defaults to true.
  - `max_node_count` - The maximum number of nodes in the Spark pool. Defaults to 1.
  - `min_node_count` - The minimum number of nodes in the Spark pool. Defaults to 3.
- `cache_size` - (Optional) The size of the cache for the Spark pool.
- `custom_libraries` - (Optional) A list of custom libraries to install in the Spark pool. Each library is specified as an object with the following properties:
  - `name` - The name of the library.
  - `version` - The version of the library.
  - `uri` - The URI of the library.
- `default_spark_log_folder` - (Optional) The default folder for Spark logs.
- `spark_events_folder` - (Optional) The folder for Spark events.
- `dynamic_executor_allocation` - (Optional) A map of dynamic executor allocation settings for the Spark pool. The following properties can be specified:
  - `enabled` - Whether to enable dynamic executor allocation. Defaults to true.
  - `max_executors` - The maximum number of executors in the Spark pool.
  - `min_executors` - The minimum number of executors in the Spark pool.
- `is_autotune_enabled` - (Optional) Whether to enable autotune for the Spark pool. Defaults to false.
- `is_compute_isolation_enabled` - (Optional) Whether to enable compute isolation for the Spark pool. Defaults to false.
- `library_requirements` - (Optional) A map of library requirements for the Spark pool. The following properties can be specified:
  - `content` - The content of the library requirements.
  - `filename` - The filename of the library requirements.
- `node_count` - (Optional) The number of nodes in the Spark pool. Either autos_scale or node_count needs to be configured .Defaults to 0.
- `session_level_packages_enabled` - (Optional) Whether to enable session level packages for the Spark pool. Defaults to false.
- `spark_config_properties` - (Optional) A map of Spark configuration properties for the Spark pool. The following properties can be specified:
  - `content` - The content of the Spark configuration properties.
  - `filename` - The filename of the Spark configuration properties.
- `tags` - (Optional) A map of tags to assign to the Spark pool.
DESCRIPTION

}
