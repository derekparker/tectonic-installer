resource "template_dir" "experimental" {
  count           = "${var.experimental_enabled ? 1 : 0}"
  source_dir      = "${path.module}/resources/experimental/manifests"
  destination_dir = "./generated/experimental"

  vars {
    etcd_operator_image = "${var.container_images["etcd_operator"]}"
    etcd_service_ip     = "${cidrhost(var.service_cidr, 15)}"
    kenc_image          = "${var.container_images["kenc"]}"

    etcd_ca_cert = "${base64encode(var.etcd_ca_cert_pem)}"

    etcd_server_cert = "${base64encode(var.etcd_server_cert_pem)}"
    etcd_server_key  = "${base64encode(var.etcd_server_key_pem)}"

    etcd_client_cert = "${base64encode(var.etcd_client_cert_pem)}"
    etcd_client_key  = "${base64encode(var.etcd_client_key_pem)}"

    etcd_peer_cert = "${base64encode(var.etcd_peer_cert_pem)}"
    etcd_peer_key  = "${base64encode(var.etcd_peer_key_pem)}"
  }
}

resource "template_dir" "bootstrap_experimental" {
  count           = "${var.experimental_enabled ? 1 : 0}"
  source_dir      = "${path.module}/resources/experimental/bootstrap-manifests"
  destination_dir = "./generated/bootstrap-experimental"

  vars {
    etcd_image                = "${var.container_images["etcd"]}"
    etcd_version              = "${var.versions["etcd"]}"
    bootstrap_etcd_service_ip = "${cidrhost(var.service_cidr, 20)}"
  }
}

resource "template_dir" "etcd_experimental" {
  count           = "${var.experimental_enabled ? 1 : 0}"
  source_dir      = "${path.module}/resources/experimental/etcd"
  destination_dir = "./generated/etcd"

  vars {
    etcd_version              = "${var.versions["etcd"]}"
    bootstrap_etcd_service_ip = "${cidrhost(var.service_cidr, 20)}"
  }
}

# Self-hosted manifests (resources/generated/manifests/)
resource "template_dir" "bootkube" {
  source_dir      = "${path.module}/resources/manifests"
  destination_dir = "./generated/manifests"

  vars {
    kube_version_operator_image = "${var.container_images["kube_version_operator"]}"
    pull_secret                 = "${base64encode(file(var.pull_secret_path))}"
    hyperkube_image             = "${var.container_images["hyperkube"]}"
    pod_checkpointer_image      = "${var.container_images["pod_checkpointer"]}"
    kubedns_image               = "${var.container_images["kubedns"]}"
    kubednsmasq_image           = "${var.container_images["kubednsmasq"]}"
    kubedns_sidecar_image       = "${var.container_images["kubedns_sidecar"]}"

    # Choose the etcd endpoints to use.
    # 1. If experimental mode is enabled (self-hosted etcd), then use
    # var.etcd_service_ip.
    # 2. Else if no etcd TLS certificates are provided, i.e. we bootstrap etcd
    # nodes ourselves (using http), then use insecure http var.etcd_endpoints.
    # 3. Else (if etcd TLS certific are provided), then use the secure https
    # var.etcd_endpoints.
    etcd_servers = "${
      var.experimental_enabled
        ? format("https://%s:2379", cidrhost(var.service_cidr, 15))
        : var.etcd_ca_cert_pem == ""
          ? join(",", formatlist("http://%s:2379", var.etcd_endpoints))
          : join(",", formatlist("https://%s:2379", var.etcd_endpoints))
      }"

    etcd_service_ip           = "${cidrhost(var.service_cidr, 15)}"
    bootstrap_etcd_service_ip = "${cidrhost(var.service_cidr, 20)}"

    cloud_provider             = "${var.cloud_provider}"
    cloud_provider_config      = "${var.cloud_provider_config}"
    cloud_provider_config_flag = "${var.cloud_provider_config != "" ? "- --cloud-config=/etc/kubernetes/cloud/config" : "# no cloud provider config given"}"

    cluster_cidr        = "${var.cluster_cidr}"
    service_cidr        = "${var.service_cidr}"
    kube_dns_service_ip = "${cidrhost(var.service_cidr, 10)}"
    advertise_address   = "${var.advertise_address}"

    anonymous_auth      = "${var.anonymous_auth}"
    oidc_issuer_url     = "${var.oidc_issuer_url}"
    oidc_client_id      = "${var.oidc_client_id}"
    oidc_username_claim = "${var.oidc_username_claim}"
    oidc_groups_claim   = "${var.oidc_groups_claim}"
    oidc_ca_cert        = "${base64encode(var.oidc_ca_cert)}"

    kube_ca_cert       = "${base64encode(var.kube_ca_cert_pem)}"
    apiserver_key      = "${base64encode(var.apiserver_key_pem)}"
    apiserver_cert     = "${base64encode(var.apiserver_cert_pem)}"
    serviceaccount_pub = "${base64encode(tls_private_key.service_account.public_key_pem)}"
    serviceaccount_key = "${base64encode(tls_private_key.service_account.private_key_pem)}"

    etcd_ca_flag   = "${var.etcd_ca_cert_pem != "" ? "- --etcd-cafile=/etc/kubernetes/secrets/etcd-client-ca.crt" : "# no etcd-client-ca.crt given" }"
    etcd_cert_flag = "${var.etcd_client_cert_pem != "" ? "- --etcd-certfile=/etc/kubernetes/secrets/etcd-client.crt" : "# no etcd-client.crt given" }"
    etcd_key_flag  = "${var.etcd_client_key_pem != "" ? "- --etcd-keyfile=/etc/kubernetes/secrets/etcd-client.key" : "# no etcd-client.key given" }"

    etcd_ca_cert     = "${base64encode(var.etcd_ca_cert_pem)}"
    etcd_client_cert = "${base64encode(var.etcd_client_cert_pem)}"
    etcd_client_key  = "${base64encode(var.etcd_client_key_pem)}"

    kubernetes_version = "${replace(var.versions["kubernetes"], "+", "-")}"

    master_count              = "${var.master_count}"
    node_monitor_grace_period = "${var.node_monitor_grace_period}"
    pod_eviction_timeout      = "${var.pod_eviction_timeout}"

    cloud_provider_profile = "${var.cloud_provider != "" ? "${var.cloud_provider}" : "metal"}"
    cloud_config_path      = "${var.cloud_config_path}"
  }
}

<<<<<<< 0f17a57def561bc7402e528a65149a126b7c1ab1
# Self-hosted bootstrapping manifests (resources/generated/manifests-bootstrap/)
resource "template_dir" "bootkube_bootstrap" {
  source_dir      = "${path.module}/resources/bootstrap-manifests"
  destination_dir = "./generated/bootstrap-manifests"

  vars {
    hyperkube_image = "${var.container_images["hyperkube"]}"
    etcd_image      = "${var.container_images["etcd"]}"

    # Choose the etcd endpoints to use.
    # 1. If experimental mode is enabled (self-hosted etcd), then use
    # var.etcd_service_ip.
    # 2. Else if no etcd TLS certificates are provided, i.e. we bootstrap etcd
    # nodes ourselves (using http), then use insecure http var.etcd_endpoints.
    # 3. Else (if etcd TLS certific are provided), then use the secure https
    # var.etcd_endpoints.
    etcd_servers = "${
      var.experimental_enabled
        ? format("https://%s:2379,https://127.0.0.1:12379", cidrhost(var.service_cidr, 15))
        : var.etcd_ca_cert_pem == ""
          ? join(",", formatlist("http://%s:2379", var.etcd_endpoints))
          : join(",", formatlist("https://%s:2379", var.etcd_endpoints))
      }"

    etcd_ca_flag   = "${var.etcd_ca_cert_pem != "" ? "- --etcd-cafile=/etc/kubernetes/secrets/etcd-client-ca.crt" : "# no etcd-client-ca.crt given" }"
    etcd_cert_flag = "${var.etcd_client_cert_pem != "" ? "- --etcd-certfile=/etc/kubernetes/secrets/etcd-client.crt" : "# no etcd-client.crt given" }"
    etcd_key_flag  = "${var.etcd_client_key_pem != "" ? "- --etcd-keyfile=/etc/kubernetes/secrets/etcd-client.key" : "# no etcd-client.key given" }"

    cloud_provider             = "${var.cloud_provider}"
    cloud_provider_config      = "${var.cloud_provider_config}"
    cloud_provider_config_flag = "${var.cloud_provider_config != "" ? "- --cloud-config=/etc/kubernetes/cloud/config" : "# no cloud provider config given"}"

    advertise_address = "${var.advertise_address}"
    cluster_cidr      = "${var.cluster_cidr}"
    service_cidr      = "${var.service_cidr}"
  }
}

# kubeconfig (resources/generated/auth/kubeconfig)
data "template_file" "kubeconfig" {
  template = "${file("${path.module}/resources/kubeconfig")}"

  vars {
    kube_ca_cert = "${base64encode(var.kube_ca_cert_pem)}"
    kubelet_cert = "${base64encode(var.kubelet_cert_pem)}"
    kubelet_key  = "${base64encode(var.kubelet_key_pem)}"
    server       = "${var.kube_apiserver_url}"
    cluster_name = "${var.cluster_name}"
  }
}

resource "local_file" "kubeconfig" {
  content  = "${data.template_file.kubeconfig.rendered}"
  filename = "./generated/auth/kubeconfig"
}

# bootkube.sh (resources/generated/bootkube.sh)
data "template_file" "bootkube_sh" {
  template = "${file("${path.module}/resources/bootkube.sh")}"

  vars {
    bootkube_image = "${var.container_images["bootkube"]}"
  }
}

resource "local_file" "bootkube_sh" {
  content  = "${data.template_file.bootkube_sh.rendered}"
  filename = "./generated/bootkube.sh"
}

resource "local_file" "kvo_config" {
  content  = "${data.template_file.kvo_config.rendered}"
  filename = "./generated/kvo-config.yaml"
}

resource "local_file" "pull_secret" {
  content  = "${file(var.pull_secret_path)}"
  filename = "./generated/config.json"
}

# bootkube.service (available as output variable)
data "template_file" "bootkube_service" {
  template = "${file("${path.module}/resources/bootkube.service")}"
}

# kvo.service (available as output variable)
data "template_file" "kvo_service" {
  template = "${file("${path.module}/resources/kvo.service")}"
  vars {
    kube_version_operator_image = "${var.container_images["kube_version_operator"]}"
    kubernetes_version          = "${var.versions["kubernetes"]}"
  }
}

data "template_file" "kvo_config" {
  template = "${file("${path.module}/resources/kvo-config.yaml")}"
  vars {
    oidc_issuer_url     = "${var.oidc_issuer_url}"
    oidc_client_id      = "${var.oidc_client_id}"
    oidc_username_claim = "${var.oidc_username_claim}"
    oidc_groups_claim   = "${var.oidc_groups_claim}"

    cloud_provider_profile = "${var.cloud_provider != "" ? "${var.cloud_provider}" : "metal"}"
    cloud_config_path      = "${var.cloud_config_path}"

    cluster_cidr        = "${var.cluster_cidr}"
    service_cidr        = "${var.service_cidr}"
    advertise_address   = "${var.advertise_address}"
    etcd_servers = "${
      var.experimental_enabled
        ? format("https://%s:2379", cidrhost(var.service_cidr, 15))
        : var.etcd_ca_cert_pem == ""
          ? join(",", formatlist("http://%s:2379", var.etcd_endpoints))
          : join(",", formatlist("https://%s:2379", var.etcd_endpoints))
      }"

    master_count = "${var.master_count}"
  }
}

data "ignition_systemd_unit" "bootkube_service" {
  name    = "bootkube.service"
  enable  = false
  content = "${data.template_file.bootkube_service.rendered}"
}

data "ignition_systemd_unit" "kvo_service" {
  name    = "kvo.service"
  enable  = true
  content = "${data.template_file.kvo_service.rendered}"
}

# bootkube.path (available as output variable)
data "template_file" "bootkube_path_unit" {
  template = "${file("${path.module}/resources/bootkube.path")}"
}

data "ignition_systemd_unit" "bootkube_path_unit" {
  name    = "bootkube.path"
  enable  = true
  content = "${data.template_file.bootkube_path_unit.rendered}"
}
