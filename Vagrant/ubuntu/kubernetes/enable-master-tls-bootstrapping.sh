echo "Enabling TLS bootstrapping..."
sleep 30

# Create the Boostrap Token

cat <<EOF | tee bootstrap-token-07401c.yaml > /dev/null
apiVersion: v1
kind: Secret
metadata:
  # Name MUST be of form "bootstrap-token-<token id>"
  name: bootstrap-token-07401c
  namespace: kube-system

# Type MUST be 'bootstrap.kubernetes.io/token'
type: bootstrap.kubernetes.io/token
stringData:
  # Human readable description. Optional.
  description: "The default bootstrap token generated by 'kubeadm init'."

  # Token ID and secret. Required.
  token-id: 07401c
  token-secret: f395accd246ae52d

  # Expiration. Optional.
  expiration: 2021-12-29T22:04:00Z

  # Allowed usages.
  usage-bootstrap-authentication: "true"
  usage-bootstrap-signing: "true"

  # Extra groups to authenticate the token as. Must start with "system:bootstrappers:"
  auth-extra-groups: system:bootstrappers:worker
EOF

kubectl create -f bootstrap-token-07401c.yaml --kubeconfig admin.kubeconfig


# Authorize workers(kubelets) to create CSR

cat <<EOF | tee csrs-for-bootstrapping.yaml > /dev/null
# enable bootstrapping nodes to create CSR
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: create-csrs-for-bootstrapping
subjects:
- kind: Group
  name: system:bootstrappers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:node-bootstrapper
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl create -f csrs-for-bootstrapping.yaml --kubeconfig admin.kubeconfig


# Authorize workers(kubelets) to approve CSR

cat <<EOF | tee auto-approve-csrs-for-group.yaml > /dev/null
# Approve all CSRs for the group "system:bootstrappers"
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: auto-approve-csrs-for-group
subjects:
- kind: Group
  name: system:bootstrappers
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:certificates.k8s.io:certificatesigningrequests:nodeclient
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl create -f auto-approve-csrs-for-group.yaml --kubeconfig admin.kubeconfig


# Authorize workers(kubelets) to Auto Renew Certificates on expiration

cat <<EOF | tee auto-approve-renewals-for-nodes.yaml > /dev/null
# Approve renewal CSRs for the group "system:nodes"
kind: ClusterRoleBinding
apiVersion: rbac.authorization.k8s.io/v1
metadata:
  name: auto-approve-renewals-for-nodes
subjects:
- kind: Group
  name: system:nodes
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: ClusterRole
  name: system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
  apiGroup: rbac.authorization.k8s.io
EOF

kubectl create -f auto-approve-renewals-for-nodes.yaml --kubeconfig admin.kubeconfig

echo "TLS bootstrapping has been enabled."