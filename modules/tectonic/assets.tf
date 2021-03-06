# Kubernetes Manifests (resources/generated/manifests/)
## github.com/coreos-inc/tectonic/commit/0b48144d5332201cf461a309d501b33a00a26f75
resource "template_folder" "tectonic" {
  input_path  = "${path.module}/resources/manifests"
  output_path = "${path.cwd}/generated/tectonic"

  vars {
    console_image                   = "${var.container_images["console"]}"
    identity_image                  = "${var.container_images["identity"]}"
    kube_version_operator_image     = "${var.container_images["kube_version_operator"]}"
    tectonic_channel_operator_image = "${var.container_images["tectonic_channel_operator"]}"
    node_agent_image                = "${var.container_images["node_agent"]}"
    prometheus_operator_image       = "${var.container_images["prometheus_operator"]}"
    node_exporter_image             = "${var.container_images["node_exporter"]}"
    config_reload_image             = "${var.container_images["config_reload"]}"
    heapster_image                  = "${var.container_images["heapster"]}"
    addon_resizer_image             = "${var.container_images["addon_resizer"]}"
    stats_emitter_image             = "${var.container_images["stats_emitter"]}"
    stats_extender_image            = "${var.container_images["stats_extender"]}"
    error_server_image              = "${var.container_images["error_server"]}"
    ingress_controller_image        = "${var.container_images["ingress_controller"]}"

    prometheus_version = "${var.versions["prometheus"]}"
    kubernetes_version = "${var.versions["kubernetes"]}"
    tectonic_version   = "${var.versions["tectonic"]}"

    license     = "${base64encode(file(var.license_path))}"
    pull_secret = "${base64encode(file(var.pull_secret_path))}"
    ca_cert     = "${base64encode(var.ca_cert)}"

    update_server  = "${var.update_server}"
    update_channel = "${var.update_channel}"
    update_app_id  = "${var.update_app_id}"

    admin_user_id       = "${random_id.admin_user_id.b64}"
    admin_email         = "${var.admin_email}"
    admin_password_hash = "${var.admin_password_hash}"

    console_base_address = "https://${var.base_address}"
    console_client_id    = "${var.console_client_id}"
    console_secret       = "${random_id.console_secret.b64}"
    console_callback     = "https://${var.base_address}/auth/callback"

    ingress_kind     = "${var.ingress_kind}"
    ingress_tls_cert = "${base64encode(tls_locally_signed_cert.ingress.cert_pem)}"
    ingress_tls_key  = "${base64encode(tls_private_key.ingress.private_key_pem)}"

    identity_server_tls_cert = "${base64encode(tls_locally_signed_cert.identity-server.cert_pem)}"
    identity_server_tls_key  = "${base64encode(tls_private_key.identity-server.private_key_pem)}"
    identity_client_tls_cert = "${base64encode(tls_locally_signed_cert.identity-client.cert_pem)}"
    identity_client_tls_key  = "${base64encode(tls_private_key.identity-client.private_key_pem)}"

    kubectl_client_id = "${var.kubectl_client_id}"
    kubectl_secret    = "${random_id.kubectl_secret.b64}"

    kube_apiserver_url = "${var.kube_apiserver_url}"
    oidc_issuer_url    = "https://${var.base_address}/identity"

    cluster_id            = "${uuid()}"
    platform              = "${var.platform}"
    certificates_strategy = "${var.ca_generated == "true" ? "installerGeneratedCA" : "userProvidedCA"}"
  }
}

# tectonic.sh (resources/generated/tectonic.sh)
data "template_file" "tectonic" {
  template = "${file("${path.module}/resources/tectonic.sh")}"

  vars {
    ingress_kind = "${var.ingress_kind}"
  }
}

resource "localfile_file" "tectonic" {
  content     = "${data.template_file.tectonic.rendered}"
  destination = "${path.cwd}/generated/tectonic.sh"
}

# tectonic.service (available as output variable)
data "template_file" "tectonic_service" {
  template = "${file("${path.module}/resources/tectonic.service")}"
}
