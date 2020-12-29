kubectl config set-cluster kubernetes-lab \
    --certificate-authority=$HOME/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$HOME/admin.kubeconfig

kubectl config set-credentials admin \
    --client-certificate=$HOME/admin.crt \
    --client-key=$HOME/admin.key \
    --embed-certs=true \
    --kubeconfig=$HOME/admin.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-lab \
    --user=admin \
    --kubeconfig=$HOME/admin.kubeconfig

kubectl config use-context default --kubeconfig=$HOME/admin.kubeconfig
