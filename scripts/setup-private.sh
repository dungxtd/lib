cp ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust
sudo systemctl restart containerd
/usr/local/bin/crictl pull ddplatform-pvt-registry:443/zubin-ds-keyword-matching-algorithm:14204