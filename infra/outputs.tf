output "kubeconfig" {
  value     = module.eks.kubeconfig
  sensitive = true
}

output "cluster_name" {
  value = var.cluster_name
}

output "cluster_role" {
  value = module.eks.user_role_arn
}

output "region" {
  value = var.region
}

output "database_credentials" {
  value = <<EOF
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: ${var.cluster_name}
  namespace: default
data:
  postgres-username: ${base64encode(module.db.db_admin_username)} 
  postgres-password: ${base64encode(module.db.db_admin_password)} 
EOF


  sensitive = true
}

data "aws_caller_identity" "current" {
}

output "user_profile" {
description = "You can assume this role to manage the cluster"

value = <<EOF


[profile ${var.cluster_name}]
source_profile = default
role_arn = "${module.eks.user_role_arn}"
EOF


sensitive = true
}

