MASTER_VAR_LIB_KUBERNETES="/var/lib/kubernetes/"

cat <<EOF | sudo tee /var/lib/kubernetes/kube-scheduler.yaml > /dev/null
apiVersion: kubescheduler.config.k8s.io/v1alpha1
kind: KubeSchedulerConfiguration
clientConnection:
  kubeconfig: "/var/lib/kubernetes/kube-scheduler.kubeconfig"
leaderElection:
  leaderElect: true
EOF

sudo cp kube-scheduler.kubeconfig "$MASTER_VAR_LIB_KUBERNETES"

cat <<EOF | sudo tee /etc/systemd/system/kube-scheduler.service > /dev/null
[Unit]
Description=Kubernetes Scheduler
Documentation=https://github.com/kubernetes/kubernetes

[Service]
ExecStart=/usr/local/bin/kube-scheduler \\
  --config=/var/lib/kubernetes/kube-scheduler.yaml \\
  --address=127.0.0.1 \\
  --leader-elect=true \\
  --master=master-1
  --v=2
Restart=on-failure
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF
