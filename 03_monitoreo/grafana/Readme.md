`Ver en tiempo real los pods`
watch kubectl get pod -A 

`Obtener nombre node-group`
get nodegroups --cluster eks-mundos-e

`Obtener informacion de errores`
get events -n kube-system

`Revisa las cuentas de servicio en el namespace kube-system`
kubectl get serviceaccounts -n kube-system

`Verifica que la cuenta de servicio tiene el rol asociado`
kubectl describe serviceaccount ebs-csi-controller-sa -n kube-system

`Muestra todos los Persistent Volume Claims (PVCs) en el namespace`
kubectl get pvc -n prometheus

`Muestra todos los Persistent Volumes (PVs) disponibles en el clúster de Kubernetes`
kubectl get pv
