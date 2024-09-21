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

docker run --rm -it \
  --add-host ddplatform-pvt-registry:10.210.24.205 \
  -e COSIGN_PKCS11_IGNORE_CERTIFICATE=1 \
  -e SM_API_KEY=015b5f56d7812a6599884cbc68_b6c77cc17480f2a71c2b1e09a572e007dff0d53634e201ad566c1a573e30ca6b \
  -e SM_HOST=https://clientauth.one.digicert.com \
  -e SM_CLIENT_CERT_FILE=/usr/local/lib/certificate_pkcs12.p12 \
  -e SM_CLIENT_CERT_PASSWORD=eR9JeE1oeT6H \
  -v /root/cosign/certificate_pkcs12.p12:/usr/local/lib/certificate_pkcs12.p12 \
  -v /root/cosign/libp11.so:/usr/local/lib/libp11.so \
  -v /root/cosign/key_922268116.pem:/usr/local/lib/key_922268116.pem \
  -v /root/cosign/data:/data \
  cosign sh -c "\
    cosign login ddplatform-pvt-registry:443 \
      --username=ddpadmin --password=User@123 && \
    cosign clean ddplatform-pvt-registry:443/zubin-ui:16487 -f && \
    cosign sign \
      --key 'pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/usr/local/lib/libp11.so' \
      ddplatform-pvt-registry:443/zubin-ui:16487 \
      -y -a author='Data Dynamics' -a project='Zubin' -a signedDate='$(date +%Y-%m-%dT%H:%M:%S)' && \
    cosign verify \
      --key 'pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/usr/local/lib/libp11.so' \
      ddplatform-pvt-registry:443/zubin-ui:16487 | jq . && \
    cosign save --dir /data/ddplatform-pvt-registry:443/zubin-ui:16487 ddplatform-pvt-registry:443/zubin-ui:16487
    "

docker run --rm -it \
  --add-host ddplatform-pvt-registry:10.210.24.205 \
  -e COSIGN_PKCS11_IGNORE_CERTIFICATE=1 \
  -e SM_API_KEY=015b5f56d7812a6599884cbc68_b6c77cc17480f2a71c2b1e09a572e007dff0d53634e201ad566c1a573e30ca6b \
  -e SM_HOST=https://clientauth.one.digicert.com \
  -e SM_CLIENT_CERT_FILE=/usr/local/lib/certificate_pkcs12.p12 \
  -e SM_CLIENT_CERT_PASSWORD=eR9JeE1oeT6H \
  -v /root/cosign/certificate_pkcs12.p12:/usr/local/lib/certificate_pkcs12.p12 \
  -v /root/cosign/libp11.so:/usr/local/lib/libp11.so \
  -v /root/cosign/key_922268116.pem:/usr/local/lib/key_922268116.pem \
  -v /root/cosign/data:/data \
  cosign sh -c "\
    cosign clean 10.210.60.130:5000/zubin-ui:16487 -f && \
    cosign load --dir /data/ddplatform-pvt-registry:443/zubin-ui:16487 10.210.60.130:5000/zubin-ui:16487 && \
    cosign verify \
      --key 'pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/usr/local/lib/libp11.so' \
      10.210.60.130:5000/zubin-ui:16487 | jq .
    "