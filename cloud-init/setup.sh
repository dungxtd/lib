dpkg -l | grep open-vm-tools
apt install open-vm-tools
vmtoolsd -v
systemctl enable open-vm-tools.service
systemctl start open-vm-tools.service
systemctl is-enabled open-vm-tools.service
systemctl status open-vm-tools.service

dpkg -l | grep -w cloud-init
apt install cloud-init
dpkg -l | grep -w cloud-init
systemctl status cloud-init.service
systemctl enable cloud-init.service
sudo systemctl is-enabled cloud-init.service
cat /etc/cloud/cloud.cfg | grep datasource
# If you use datasource_list array, keep array items in a single line.
# Example datasource config
# datasource:
dpkg-reconfigure cloud-init
cloud-init clean --logs

sudo cloud-init clean
sudo cloud-init init
sudo cloud-init modules --mode=config
sudo cloud-init modules --mode=final
