# Telemetry was removed. Existing states still hold the telemetry resource;
# forget it without calling the provider. random_uuid.telemetry is destroyed
# normally, it never left the state file.
removed {
  from = modtm_telemetry.telemetry

  lifecycle {
    destroy = false
  }
}
