CNI_PLUGINS="/tmp/cni-plugins.tgz"

echo "Installing cni plugins..."
sudo tar -xzvf "$CNI_PLUGINS" --directory "$WORKER_OPT_CNI_BIN"
