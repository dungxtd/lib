curl -O -L "https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-pivkey-pkcs11key-amd64"
sudo mv cosign-linux-pivkey-pkcs11key-amd64 /usr/local/bin/cosign
sudo chmod +x /usr/local/bin/cosign


COSIGN_PKCS11_IGNORE_CERTIFICATE=1 cosign sign --key "pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/usr/local/lib/libp11.so" ddplatform-pvt-registry:443/zubin-ui:16461 -y -a author="Data Dynamics" -a project="Zubin"


cosign verify --key "pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/usr/local/lib/libp11.so" 10.210.60.130:5000/zubin-ui:16461 | jq .

docker run -d -p 5000:5000 registry

cosign copy 10.210.60.130:5000/zubin-documentation:15046 localhost:5000/zubin-documentation:15046

cosign save --dir /home/temp/zubin-ui_16461 ddplatform-pvt-registry:443/zubin-ui:16461

tar -czvf /home/temp/zubin-ui_16461.tgz zubin-ui_16461

scp devops@10.210.60.140:/home/temp/zubin-ui_16461.tgz /home/temp/

tar -xzvf zubin-ui_16461.tgz -C ./

nerdctl run --rm -it   -v /usr/local/lib:/usr/local/lib -v /home/temp:/home/temp   gcr.io/projectsigstore/cosign load --dir /home/temp/zubin-documentation_15046 localhost:5000/zubin-documentation:15046

sudo chmod -R 777 /home/temp

nerdctl run --rm -it   -v /usr/local/lib:/usr/local/lib -v /home/temp:/home/temp   gcr.io/projectsigstore/cosign load --dir /home/temp/zubin-ui_16461 10.210.60.130:5000/zubin-ui:16461

ddplatform-pvt-registry:443/zubin-ui:16461