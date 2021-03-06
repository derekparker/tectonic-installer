variable "container_images" {
    description = "Container images to use. Leave blank for defaults."
    type = "map"
}

variable "versions" {
    description = "Versions of the components to use. Leave blank for defaults."
    type = "map"
}

variable "platform" {
    description = "Platform on which Tectonic is being installed. Example: bare-metal or aws."
    type        = "string"
}

variable "ingress_kind" {
    description = "Type of Ingress mapping to use. Example: HostPort or NodePort."
    type        = "string"
}

variable "license_path" {
    description = "Path on disk to your Tectonic license. Obtain this from your Tectonic Account: https://account.coreos.com."
    type        = "string"
    default = "/Users/coreos/Desktop/tectonic-license.txt"
}

variable "pull_secret_path" {
    type        = "string"
    description = "Path on disk to your Tectonic pull secret. Obtain this from your Tectonic Account: https://account.coreos.com."
    default = "/Users/coreos/Desktop/config.json"
}

variable "ca_generated" {
    description = "Define whether the CA has been generated or user-provided."
    type        = "string"
}

variable "ca_cert" {
    description = "Contents of a PEM-encoded CA certificate, used to generate Tectonic Console's server certificate. Leave blank to generate a new CA."
    type        = "string"
}

variable "ca_key_alg" {
    description = "Algorithm used to generate ca_key. Example: RSA."
    type        = "string"
}

variable "ca_key" {
    description = "Contents of a PEM-encoded CA key, used to generate Tectonic Console's server certificate. Leave blank to generate a new CA."
    type        = "string"
}

variable "base_address" {
    description = "Base address used to access the Tectonic Console, without protocol nor trailing forward slash (may contain a port). Example: console.example.com:30000."
    type        = "string"
}

variable "admin_email" {
    description = "E-mail address used to log in to the Tectonic Console."
    type        = "string"
    default = "admin@example.com"
}

variable "admin_password_hash" {
    description = "Hashed password used to by the cluster admin to login to the Tectonic Console. Generate with the bcrypt-hash tool (https://github.com/coreos/bcrypt-tool/releases/tag/v1.0.0)."
    type        = "string"
    default = "2a$12$k9wa31uE/4uD9aVtT/vNtOZwxXyEJ/9DwXXEYB/eUpb9fvEPsH/kO"
}

variable "update_server" {
    description = "Server contacted to request Tectonic software updates. Leave blank for defaults."
    type        = "string"
}

variable "update_channel" {
    description = "Release channel used to request Tectonic software updates. Leave blank for defaults. Example: Tectonic-1.5"
    type        = "string"
}

variable "update_app_id" {
    description = "Application identifier used to request Tectonic software updates. Leave blank for defaults."
    type        = "string"
}

variable "console_client_id" {
    description = "OIDC identifier for the Tectonic Console. Leave blank for defaults."
    type        = "string"
}

variable "kubectl_client_id" {
    description = "OIDC identifier for kubectl. Leave blank for defaults."
    type        = "string"
}

variable "kube_apiserver_url" {
    description = "URL used to reach kube-apiserver. Leave blank for defaults."
    type        = "string"
}