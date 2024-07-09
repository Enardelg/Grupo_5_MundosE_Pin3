#!/bin/bash
#  --GRAFANA--
# 1-. Crea el espacio para grafana
kubectl create namespace grafana
# 2-. Agregar el repositorio de Helm de Grafana:
helm repo add grafana https://grafana.github.io/helm-charts
# 3-. Actualiza los repositorios de Helm
helm repo update
# 4-. Cree un archivo YAML llamado grafana.yml
helm install grafana grafana/grafana \
  --namespace grafana \
  --set persistence.storageClassName="gp2" \
  --set persistence.enabled=true \
  --set adminPassword=cuturul \
  --values /home/ubuntu/grafana/grafana.yml \
  --set service.type=LoadBalancer \
  --force
# 5-. Compruebe si Grafana se despliega correctamente
kubectl get all -n grafana
# 6-. Obtener la url del loadbalancer de Grafana
export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "http://$ELB"
# 7-. Utilice el nombre de usuario "admin" y obtenga la contraseña ejecutando lo siguiente:
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode; echo
# 8-. Obtener los servicios, copiar el link del loadbalancer para acceder al dash de grafana
kubectl get svc -n grafana
# 9-. Por si necesitas volver a instalar algo
helm uninstall grafana -n grafana
