WORKER_ETC_CNI_NET_D="/etc/cni/net.d"
WORKER_ETC_CNI_BIN="/opt/cni/bin"
WORKER_VAR_LIB_KUBELET="/var/lib/kubelet"
WORKER_VAR_LIB_KUBE_PROXY="/var/lib/kube-proxy"
WORKER_VAR_LIB_KUBERNETES="/var/lib/kubernetes"
WORKER_VAR_RUN_KUBERNETES="/var/run/kubernetes"

sudo mkdir -p \
  "$WORKER_ETC_CNI_NET_D" \
  "$WORKER_ETC_CNI_BIN" \
  "$WORKER_VAR_LIB_KUBELET" \
  "$WORKER_VAR_LIB_KUBE_PROXY" \
  "$WORKER_VAR_LIB_KUBERNETES" \
  "$WORKER_VAR_RUN_KUBERNETES"

sudo mv "${HOSTNAME}".key "${HOSTNAME}".crt "$WORKER_VAR_LIB_KUBELET"
sudo mv "${HOSTNAME}".kubeconfig "$WORKER_VAR_LIB_KUBELET"/kubeconfig
sudo mv ca.crt "$WORKER_VAR_LIB_KUBERNETES"


# Configure the Kubelet

cat <<EOF | sudo tee /var/lib/kubelet/kubelet-config.yaml > /dev/null
kind: KubeletConfiguration
apiVersion: kubelet.config.k8s.io/v1beta1
authentication:
  anonymous:
    enabled: false
  webhook:
    enabled: true
  x509:
    clientCAFile: "${WORKER_VAR_LIB_KUBERNETES}/ca.crt"
authorization:
  mode: Webhook
clusterDomain: "cluster.local"
clusterDNS:
  - "10.96.0.10"
resolvConf: "/run/systemd/resolve/resolv.conf"
runtimeRequestTimeout: "15m"
EOF


# Create the kubelet.service

cat <<EOF | sudo tee /etc/systemd/system/kubelet.service > /dev/null
[Unit]
Description=Kubernetes Kubelet
Documentation=https://github.com/kubernetes/kubernetes
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/kubelet \\
  --config=${WORKER_VAR_LIB_KUBELET}/kubelet-config.yaml \\
  --image-pull-progress-deadline=2m \\
  --kubeconfig=${WORKER_VAR_LIB_KUBELET}/kubeconfig \\
  --tls-cert-file=${WORKER_VAR_LIB_KUBELET}/${HOSTNAME}.crt \\
  --tls-private-key-file=${WORKER_VAR_LIB_KUBELET}/${HOSTNAME}.key \\
  --network-plugin=cni \\
  --register-node=true \\
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


# Configure the Kubernetes Proxy

cat <<EOF | sudo tee /var/lib/kube-proxy/kube-proxy-config.yaml > /dev/null
kind: KubeProxyConfiguration
apiVersion: kubeproxy.config.k8s.io/v1alpha1
clientConnection:
  kubeconfig: "${WORKER_VAR_LIB_KUBE_PROXY}/kubeconfig"
mode: "iptables"
clusterCIDR: "192.168.5.0/24"
EOF


# Create the kube-proxy.service

cat <<EOF | sudo tee /etc/systemd/system/kube-proxy.service > /dev/null
[Unit]
Description=Kubernetes Kube Proxy
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-proxy \\
  --config=${WORKER_VAR_LIB_KUBE_PROXY}/kube-proxy-config.yaml
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF


#Start the Worker Services

sudo systemctl daemon-reload
sudo systemctl enable kubelet kube-proxy
sudo systemctl start kubelet kube-proxy
