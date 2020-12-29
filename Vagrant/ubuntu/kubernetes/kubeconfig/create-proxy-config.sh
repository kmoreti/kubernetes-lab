LOADBALANCER_ADDRESS=192.168.5.30

kubectl config set-cluster kubernetes-lab \
    --certificate-authority=$HOME/ca.crt \
    --embed-certs=true \
    --server=https://${LOADBALANCER_ADDRESS}:6443 \
    --kubeconfig=$HOME/kube-proxy.kubeconfig

kubectl config set-credentials system:kube-proxy \
    --client-certificate=$HOME/kube-proxy.crt \
    --client-key=$HOME/kube-proxy.key \
    --embed-certs=true \
    --kubeconfig=$HOME/kube-proxy.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-lab \
    --user=system:kube-proxy \
    --kubeconfig=$HOME/kube-proxy.kubeconfig

kubectl config use-context default --kubeconfig=$HOME/kube-proxy.kubeconfig