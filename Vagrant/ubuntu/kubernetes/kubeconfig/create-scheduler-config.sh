kubectl config set-cluster kubernetes-lab \
    --certificate-authority=$HOME/ca.crt \
    --embed-certs=true \
    --server=https://127.0.0.1:6443 \
    --kubeconfig=$HOME/kube-scheduler.kubeconfig

kubectl config set-credentials system:kube-scheduler \
    --client-certificate=$HOME/kube-scheduler.crt \
    --client-key=$HOME/kube-scheduler.key \
    --embed-certs=true \
    --kubeconfig=$HOME/kube-scheduler.kubeconfig

kubectl config set-context default \
    --cluster=kubernetes-lab \
    --user=system:kube-scheduler \
    --kubeconfig=$HOME/kube-scheduler.kubeconfig

kubectl config use-context default --kubeconfig=kube-scheduler.kubeconfig
