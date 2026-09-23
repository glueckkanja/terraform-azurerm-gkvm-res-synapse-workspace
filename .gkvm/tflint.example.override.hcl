# Merged over the gkvm-tools azure profile tflint.example.hcl (hclmerge).
# The examples pin the shared "regions" and "naming" helper modules with
# pessimistic version ranges instead of exact versions, so relax the
# exact-version requirement while still requiring a version constraint.
rule "terraform_module_version" {
  enabled = true
  exact   = false
}
