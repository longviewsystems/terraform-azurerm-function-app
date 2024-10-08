plugin "azurerm" {
    enabled = true
    version = "0.26.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

config {
  module = true
}

# Enable rules that are good practice, but enabled by default 
# Reference: https://github.com/terraform-linters/tflint/tree/master/docs/rules
rule terraform_documented_outputs{
    enabled=true
}

rule terraform_deprecated_index{
    enabled=true
}

rule terraform_documented_variables{
    enabled=true
}

rule terraform_naming_convention {
  enabled = true
}

rule terraform_typed_variables{
    enabled=true
}

rule terraform_required_providers {
  enabled = true
}

rule terraform_required_version {
  enabled = true
}

rule terraform_standard_module_structure{
    enabled=true
}

rule terraform_unused_required_providers{
    enabled=true
}