export INSTALLATION="/home/$(logname)/installation"
export SCRIPTS="$INSTALLATION/scripts"
export CONFIG="$INSTALLATION/config"
export CERTS="$INSTALLATION/certs"
export BINARIES="$INSTALLATION/binaries"

chmod +x "$SCRIPTS"/*.sh
"$SCRIPTS"/install-kubernetes-master-binaries.sh
"$SCRIPTS"/install-and-configure-etcd-server.sh