#verify image signed:

nerdctl run --rm -it   --add-host ddplatform-pvt-registry:10.210.24.205   -e COSIGN_PKCS11_IGNORE_CERTIFICATE=1   -e SM_API_KEY=015b5f56d7812a6599884cbc68_b6c77cc17480f2a71c2b1e09a572e007dff0d53634e201ad566c1a573e30ca6b   -e SM_HOST=https://clientauth.one.digicert.com   -e SM_CLIENT_CERT_PASSWORD=eR9JeE1oeT6H   -e SM_CLIENT_CERT_FILE=/cosign/credentials/certificate_pkcs12.p12   -e PATH_COSIGN_CRES=/cosign/lib   -e PATH_COSIGN_DATA=/cosign/data   -e PATH_COSIGN_SCRIPTS=/cosign/scripts   -e PATH_COSIGN_LIB=/usr/local/lib    -v /root/kubespray-offline/docker/cosign:/cosign   localhost/kubespray-offline-cosign:latest /bin/bash -c "cosign verify --key 'pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/cosign/lib/libp11.so' 10.210.60.142:5000/zubin-ui:16931 | jq ."

#manual push unsigned Zubin image to testing:

nerdctl  login ddplatform-pvt-registry:443     --username=ddpadmin --password=User@123
nerdctl pull ddplatform-pvt-registry:443/zubin-ui:17184
nerdctl tag ddplatform-pvt-registry:443/zubin-ui:17184 localhost:5000/zubin-ui:17184
nerdctl push localhost:5000/zubin-ui:17184

nerdctl run -it   --add-host ddplatform-pvt-registry:10.210.24.205   -e COSIGN_PKCS11_IGNORE_CERTIFICATE=1   -e SM_API_KEY=015b5f56d7812a6599884cbc68_b6c77cc17480f2a71c2b1e09a572e007dff0d53634e201ad566c1a573e30ca6b   -e SM_HOST=https://clientauth.one.digicert.com   -e SM_CLIENT_CERT_PASSWORD=eR9JeE1oeT6H   -e SM_CLIENT_CERT_FILE=/cosign/credentials/certificate_pkcs12.p12   -e PATH_COSIGN_CRES=/cosign/lib   -e PATH_COSIGN_DATA=/cosign/data   -e PATH_COSIGN_SCRIPTS=/cosign/scripts   -e PATH_COSIGN_LIB=/usr/local/lib    -v /root/kubespray-offline/docker/cosign:/cosign   localhost/kubespray-offline-cosign:latest /bin/bash -c "cosign verify --key 'pkcs11:token=Virtual%20PKCS%2311%20Token;slot-id=0;id=%32%61%63%63%36%64%38%66%2d%39%35%34%63%2d%34%33%64%61%2d%61%38%32%37%2d%32%36%36%64%34%30%37%66%63%66%34%62;object=key_922268116?module-path=/cosign/lib/libp11.so' 10.210.60.142:5000/zubin-ui:17184 | jq ."

# apply with unsigned Zubin image to testing:
export KUBECONFIG=/root/kubespray-offline/outputs/zubin-cluster/artifacts/admin.conf 
kubectl set image deployment/zubin-ui zubin-ui=10.210.60.142:5000/zubin-ui:17184 -n zubin
