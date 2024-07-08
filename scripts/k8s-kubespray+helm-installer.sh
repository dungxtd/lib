# sudo apt-get update && sudo apt-get upgrade -y
sudo apt update

sudo apt install git python3 python3-pip -y

sudo apt install ansible

git clone --depth=1 https://github.com/kubernetes-sigs/kubespray.git

cd kubespray/

pip install ruamel_yaml
pip install -U -r requirements.txt

# Copy ``inventory/sample`` as ``inventory/mycluster``
cp -rfp inventory/sample inventory/mycluster

# Update Ansible inventory file with inventory builder
declare -a IPS=(10.210.255.34 10.210.255.134)

#add host to ansible
ssh-keygen -t rsa 
ssh-copy-id devops@10.210.255.34

CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}

# Review and change parameters under ``inventory/mycluster/group_vars``
cat inventory/mycluster/group_vars/all/all.yml
cat inventory/mycluster/group_vars/k8s_cluster/k8s-cluster.yml

sudo apt install ansible       # version 2.10.7+merged+base+2.10.8+dfsg-1, or
sudo apt install ansible-core  # version 2.12.0-1ubuntu0.1

sudo vi /etc/sudoers
devops ALL=(ALL) NOPASSWD: ALL

# Clean up old Kubernetes cluster with Ansible Playbook - run the playbook as root
# The option `--become` is required, as for example cleaning up SSL keys in /etc/,
# uninstalling old packages and interacting with various systemd daemons.
# Without --become the playbook will fail to run!
# And be mind it will remove the current kubernetes cluster (if it's running)!
ansible-playbook -i inventory/mycluster/hosts.yaml  --become --become-user=root reset.yml #-K

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