resource "kubernetes_manifest" "storages" {
  for_each = { for f in fileset("${path.module}/../../../k8s/storages", "*.yaml") : f => f }
  manifest = yamldecode(file("${path.module}/../../../k8s/storages/${each.value}"))
}

resource "kubernetes_manifest" "services" {
  for_each = { for f in fileset("${path.module}/../../../k8s/services", "*.yaml") : f => f }
  manifest = yamldecode(file("${path.module}/../../../k8s/services/${each.value}"))
}

resource "kubernetes_manifest" "deployments" {
  depends_on = [kubernetes_manifest.storages]
  for_each   = { for f in fileset("${path.module}/../../../k8s/deployments", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.module}/../../../k8s/deployments/${each.value}"))
}

resource "kubernetes_manifest" "ingress" {
  depends_on = [kubernetes_manifest.services]
  for_each   = { for f in fileset("${path.module}/../../../k8s/ingress", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.module}/../../../k8s/ingress/${each.value}"))
}

resource "kubernetes_manifest" "jobs" {
  depends_on = [kubernetes_manifest.deployments, kubernetes_manifest.services]
  for_each   = { for f in fileset("${path.module}/../../../k8s/jobs", "*.yaml") : f => f }
  manifest   = yamldecode(file("${path.module}/../../../k8s/jobs/${each.value}"))
}