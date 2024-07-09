#!/bin/bash
#  --PROMETHEUS--
# Aplica recursos del controlador Amazon EBS CSI (Container Storage Interface) en tu clúster
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.32"
----------------------------------------------------------------------------------------------------------------------------
#Configurar e instalar Prometheus en tu clúster Kubernetes utilizando Helm
#1-. Crear el espacio 
kubectl create namespace prometheus
#2-. Agregar un repositorio de Helm a tu entorno local
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
#3-. Instalar Prometheus con volúmens persistentes:
helm install prometheus prometheus-community/prometheus \
  --namespace prometheus \
  --set alertmanager.persistentVolume.storageClass="gp2" && \
helm install alertmanager prometheus-community/alertmanager \
  --namespace prometheus \
  --set alertmanager.persistentVolume.storageClass="gp2"
#||IMPORTANTE|| Tome nota del punto final de Prometheus en la respuesta del timón (lo necesitará más adelante). Debería verse similar al siguiente:
#The Prometheus server can be accessed via port 80 on the following DNS name from within your cluster:
#*prometheus-server.prometheus.svc.cluster.local*
#||IMPORTANTE|| *Puede pasar que no veas Bound en estos recursos: prometheus-server, storage-alertmanager-0, storage-prometheus-alertmanager-0
kubectl get pvc -n prometheus
# crea un archivo persistent-volume.yml 
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-pvc
  namespace: prometheus  # Asegúrate de especificar el namespace correcto
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 10Gi  # Tamaño del almacenamiento requerido
  storageClassName: gp2  # Asegúrate de usar el storageClassName correcto
kubectl apply -f persistent-volume.yml

# Sino edita el recurso que presenta "pending", en el apartado (spec) por ejemplo:
kubectl edit pvc storage-prometheus-alertmanager-0 -n prometheus

kind: PersistentVolumeClaim
metadata:
  creationTimestamp: "2024-06-30T17:15:15Z"
  finalizers:
  - kubernetes.io/pvc-protection
  labels:
    app.kubernetes.io/instance: prometheus
    app.kubernetes.io/name: alertmanager
  name: storage-prometheus-alertmanager-0
  namespace: prometheus
  resourceVersion: "9603"
  uid: b41ee3af-f758-4a4e-86bf-910af1183cc8
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 2Gi
  storageClassName: gp2  # ACA TA EL PROBLEMA
  volumeMode: Filesystem
status:
  phase: Pending
#4-. Verificar si los pods estan activos
kubectl get pods --namespace=prometheus
#5-. ¡Alertmanager y server pod están en paso pendiente!
esto ocurre porque el servidor prometheus quiere utilizar el controlador ebs pero no hay ningún controlador ebs csi instalado.
#6-.  Crear un proveedor de identidad IAM OIDC
eksctl upgrade cluster --name eks-mundos-e --approve
eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=kubectl-cluster --approve

***************************************************************************************
Crear rol con una servicio con la politica AmazonEBSCSIDriverPolicy
(driver_EBS_controller_EKS)
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster eks-mundos-e \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name driver_EBS_controller_EKS
****************************************************************************************
#7-. Administrar el controlador CSI de Amazon EBS como complemento de Amazon EKS:
aws eks describe-addon-versions --addon-name aws-ebs-csi-driver
#8-. Instalar complementento (addons) EBS CSI
eksctl create addon --name aws-ebs-csi-driver \
  --cluster eks-mundos-e \
  --service-account-role-arn arn:aws:iam::851725238678:role/driver_EBS_controller_EKS \
  --force
#9-. Verifique la versión actual de su complemento CSI de Amazon EBS.
eksctl get addon --name aws-ebs-csi-driver --cluster eks-mundos-e
#10-. Actualice el complemento (revisar comando)  me funciono esto --> eksctl upgrade cluster --name eks-mundos-e --approve
eksctl update addon --name aws-ebs-csi-driver --version v1.11.4-eksbuild.1 --cluster my-cluster \
  --service-account-role-arn arn:aws:iam::111122223333:role/AmazonEKS_EBS_CSI_DriverRole --force
#11-. Verificar si los pods estan activos
kubectl get pods --namespace=prometheus
#12-. Etiquete el pod del servidor Prometheus para conectarlo con el servicio deberia ser el name de este (prometheus-server)
kubectl label pod <pod-name> app=prometheus
#13-. Redirigir puerto
kubectl port-forward -n prometheus deploy/prometheus-server 8080:9090 --address 0.0.0.0
#14-. habilitar puerto 8080 en Ec2
url de prometheus= ip pública:8080
