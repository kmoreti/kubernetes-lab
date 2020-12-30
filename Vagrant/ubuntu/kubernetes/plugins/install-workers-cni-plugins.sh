CNI_PLUGINS="/tmp/cni-plugins.tgz"
echo "Installing cni plugins..."
sudo tar -xzvf "$CNI_PLUGINS" --directory /opt/cni/bin/