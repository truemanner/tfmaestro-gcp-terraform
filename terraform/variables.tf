variable "project_id" {
  description = "ID projektu GCP, w którym tworzone są zasoby"
  type        = string
}

variable "region" {
  description = "Domyślny region GCP"
  type        = string
  default     = "europe-central2"
}

variable "zone" {
  description = "Domyślna strefa GCP dla instancji Compute Engine"
  type        = string
  default     = "europe-central2-a"
}
