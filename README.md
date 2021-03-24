# Google Cloud monitoring

Example usage:

```
provider "google" {
  project      = "my-infrastructure"
  region       = "europe-west1"
  zone         = "europe-west1-b"
}

resource "google_project_service" "compute" {
  service      = "compute.googleapis.com"
}

resource "google_project_service" "monitoring" {
  service      = "monitoring.googleapis.com"
}

module "monitoring" {
  source       = "TaitoUnited/monitoring/google"
  version      = "1.0.0"
  providers    = [ google ]
  depends_on   = [
    google_project_service.compute,
    google_project_service.monitoring,
  ]

  alerts       = yamldecode(file("${path.root}/../infra.yaml"))["alerts"]
}
```

Example YAML:

```
# NOTE: This module does not currently create notification channels.
# You have to create them manually (e.g. the 'monitoring' channel shown below).

alerts:
  - name: ingress-response-time
    type: log
    channels: [ "monitoring" ]
    rule: >
      resource.type = "k8s_container"
      resource.labels.namespace_name = "ingress-nginx"
      jsonPayload.responseTimeS >= 3
  - name: ingress-response-status
    type: log
    channels: [ "monitoring" ]
    rule: >
      resource.type = "k8s_container"
      resource.labels.namespace_name = "ingress-nginx"
      jsonPayload.status >= 500
  - name: container-errors
    type: log
    channels: [ "monitoring" ]
    rule: >
      resource.type = "k8s_container"
      severity >= ERROR
```

Combine with the following modules to get a complete infrastructure defined by YAML:

- [Admin](https://registry.terraform.io/modules/TaitoUnited/admin/google)
- [DNS](https://registry.terraform.io/modules/TaitoUnited/dns/google)
- [Network](https://registry.terraform.io/modules/TaitoUnited/network/google)
- [Kubernetes](https://registry.terraform.io/modules/TaitoUnited/kubernetes/google)
- [Databases](https://registry.terraform.io/modules/TaitoUnited/databases/google)
- [Storage](https://registry.terraform.io/modules/TaitoUnited/storage/google)
- [Monitoring](https://registry.terraform.io/modules/TaitoUnited/monitoring/google)
- [Integrations](https://registry.terraform.io/modules/TaitoUnited/integrations/google)
- [PostgreSQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/postgresql)
- [MySQL privileges](https://registry.terraform.io/modules/TaitoUnited/privileges/mysql)

TIP: Similar modules are also available for AWS, Azure, and DigitalOcean. All modules are used by [infrastructure templates](https://taitounited.github.io/taito-cli/templates#infrastructure-templates) of [Taito CLI](https://taitounited.github.io/taito-cli/). See also [Google Cloud project resources](https://registry.terraform.io/modules/TaitoUnited/project-resources/google), [Full Stack Helm Chart](https://github.com/TaitoUnited/taito-charts/blob/master/full-stack), and [full-stack-template](https://github.com/TaitoUnited/full-stack-template).

Contributions are welcome!
