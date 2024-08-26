# sudo apt-get update && sudo apt-get upgrade -y

git clone --depth=1 https://github.com/kubernetes-sigs/kubespray.git
cd $KUBESPRAYDIR

python -m venv kubespray-venv
source kubespray-venv/bin/activate
pip install -U -r requirements.txt

pip install -U ruamel_yaml

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(10.210.30.61 10.210.30.62)

#add host to ansible
ssh-keygen -t rsa 
ssh-copy-id root@10.210.30.60
ssh-copy-id root@10.210.30.61
ssh-copy-id root@10.210.30.62

CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

sudo vi /etc/sudoers
devops ALL=(ALL) NOPASSWD: ALL

# Clean up old Kubernetes cluster with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example cleaning up SSL keys in /etc/,
# uninstalling old packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
# And be mind it will remove the current kubernetes cluster (if it's running)!
ansible-playbook -i inventory/mycluster/hosts.yaml reset.yml -e kube_version=v1.29.5 --become --become-user=root -kK --timeout 30

# Deploy Kubespray with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example writing SSL keys in /etc/,
# installing packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root cluster.yml #-K

#check version k8s
kubectl version --short
kubectl cluster-info

#export k8s  
cat /etc/kubernetes/admin.conf
cat ~/.kube/config
kubectl config view --minify


#change permission to current user
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

sudo chown -R $(id -u):$(id -g) $HOME/.kube/

#install helm
curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get-helm-3 > get_helm.sh
chmod 700 get_helm.sh
./get_helm.sh

# to repo helm file
sudo wget https://github.com/helmfile/helmfile/releases/download/v0.166.0/helmfile_0.166.0_linux_amd64.tar.gz
sudo tar -xxf helmfile_0.166.0_linux_amd64.tar.gz
sudo rm helmfile_0.166.0_linux_amd64.tar.gz
sudo mv helmfile /usr/local/bin/

# install helm diff
helm plugin install https://github.com/databus23/helm-diff


adduser devops && usermod -aG sudo devops && su devops
ansible-playbook cluster.yml -i inventory/mycluster/hosts.yaml -e kube_version=v1.29.5 --become --become-user=root -kK --timeout 30

ansible-playbook -i inventory/qe/hosts.yaml  --become --become-user=root --user=devops scale.yml --limit=region2 -K