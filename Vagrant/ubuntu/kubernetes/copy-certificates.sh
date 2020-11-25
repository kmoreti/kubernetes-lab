MASTER_VAR_LIB_KUBERNETES="/var/lib/kubernetes/"

sudo mkdir -p "$MASTER_VAR_LIB_KUBERNETES"

sudo cp ca.crt ca.key kube-apiserver.crt kube-apiserver.key \
    service-account.key service-account.crt \
    etcd-server.key etcd-server.crt \
    encryption-config.yaml "$MASTER_VAR_LIB_KUBERNETES"