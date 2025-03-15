helm repo update
helm install metallb metallb/metallb -n metallb-system

kubectl apply -f metallb-config.yaml

kubectl get ipaddresspools -n metallb-system
kubectl get l2advertisements -n metallb-system