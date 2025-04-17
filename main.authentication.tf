resource "random_password" "sql_admin_password" {
  count = var.generate_sql_admin_password == true ? 1 : 0

  length           = 22
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  min_upper        = 2
  override_special = "!#$%&()*+,-./:;<=>?@[]^_{|}~"
  special          = true
}
