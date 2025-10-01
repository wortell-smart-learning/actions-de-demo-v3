variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
  default     = "demo20251004"
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
  default     = "westeurope"
}

variable "adf_git_branch" {
  type        = string
  description = "The git branch for ADF."
  default     = "main"
}