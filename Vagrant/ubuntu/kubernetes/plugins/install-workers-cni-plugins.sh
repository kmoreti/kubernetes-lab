CNI_PLUGINS="/tmp/cni-plugins.tgz"

WORKER_ETC_CNI_NET_D="/etc/cni/net.d"
WORKER_OPT_CNI_BIN="/opt/cni/bin"

sudo mkdir -p \
  "$WORKER_ETC_CNI_NET_D" \
  "$WORKER_OPT_CNI_BIN"

echo "Installing cni plugins..."
sudo tar -xzvf "$CNI_PLUGINS" --directory "$WORKER_OPT_CNI_BIN"