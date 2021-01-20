export INSTALLATION="/home/$(logname)/installation"
export SCRIPTS="$INSTALLATION/scripts"
export CONFIG="$INSTALLATION/config"
export CERTS="$INSTALLATION/certs"
export BINARIES="$INSTALLATION/binaries"

chmod +x "$SCRIPTS"/*.sh
"$SCRIPTS"/install-kubernetes-master-binaries.sh
"$SCRIPTS"/install-and-configure-etcd-server.sh
"$SCRIPTS"/configure-kube-api-server.sh
"$SCRIPTS"/configure-kube-controller-manager.sh
"$SCRIPTS"/configure-kube-scheduler.sh
"$SCRIPTS"/start-controller-services.sh
"$SCRIPTS"/configure-client-kubectl.sh
