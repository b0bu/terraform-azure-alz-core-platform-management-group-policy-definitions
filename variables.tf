variable "management_group_id" {
  type        = string
  description = "scope at which to apply the policy"
}

variable "policy_definitions" {
  type        = map
  description = "hcl templated policy definitions output from policy-factory"
  default = {}
}
