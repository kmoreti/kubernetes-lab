export INSTALLATION="/home/$(logname)/installation"
export SCRIPTS="$INSTALLATION/scripts"
export CONFIG="$INSTALLATION/config"
export CERTS="$INSTALLATION/certs"
export BINARIES="$INSTALLATION/binaries"

chmod +x "$SCRIPTS"/*.sh

sudo cp "${CONFIG}"/daemon.json /etc/docker/daemon.json
"$SCRIPTS"/restart-docker.sh
"$SCRIPTS"/install-kubernetes-worker-binaries.sh
"$SCRIPTS"/configure-client-kubectl.sh
"$SCRIPTS"/enable-worker-tls-bootstrapping.sh
"$SCRIPTS"/deploy-weave-network.sh
