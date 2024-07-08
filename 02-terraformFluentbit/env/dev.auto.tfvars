#vpc_id      = "vpc-0a488697816d58b76" 
subnet_ids  = ["subnet-067f75599fffd7b76", "subnet-0c8aea0ec90e5ae17", "subnet-0855c13dbaa90a986"]
#account_id = "783732176237"
#vpc_security_group_ids = "sg-0fc164b8503ef7dcf"
#key_name                    = "pin2ubuntu"
#instance_name = "pin2-mundos-e"
region = "us-east-1"


grafana_values = <<EOF
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        url: http://prometheus-server.prometheus.svc.cluster.local
        access: proxy
        isDefault: true

EOF

