
kubectl config set-cluster kubernetes-lab \
    --certificate-authority=$HOME/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$HOME/kube-controller-manager.kubeconfig

kubectl config set-credentials system:kube-controller-manager \
    --client-certificate=$HOME/kube-controller-manager.crt \
    --client-key=$HOME/kube-controller-manager.key \
    --embed-certs=true \
    --kubeconfig=$HOME/kube-controller-manager.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-lab \
    --user=system:kube-controller-manager \
    --kubeconfig=$HOME/kube-controller-manager.kubeconfig

kubectl config use-context default --kubeconfig=$HOME/kube-controller-manager.kubeconfig
