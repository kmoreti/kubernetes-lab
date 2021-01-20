echo "Applying dns add-on..."
sudo -u "$(logname)" kubectl apply -f "$CONFIG"/coredns.yaml
