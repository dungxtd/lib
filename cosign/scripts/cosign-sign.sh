#!/bin/bash
cosign login ddplatform-pvt-registry:443 \
    --username=ddpadmin --password=User@123
cosign clean ${IMAGE_NAME} -f
cosign pkcs11-tool list-tokens --module-path ${PATH_COSIGN_LIB}/libp11.so
cosign pkcs11-tool list-keys-uris --module-path ${PATH_COSIGN_LIB}/libp11.so --slot-id 0 --pin anything | grep "pkcs11:token=" | while read -r line; do
    # Extract the part after "URI:" and trim the whitespace
    uri_value=$(echo "$line" | cut -d ':' -f 2- | awk '{$1=$1; print}')    
    # Extract the key label from the URI
    label=$(echo "$uri_value" | grep -oP '(?<=object=key_)\d+')
    
    echo "Signing with key $label..." 
    # Attempt to sign and catch errors
    if output=$(cosign sign \
            --key ${uri_value}  \
            ${IMAGE_NAME} \
            -y -a author='Data Dynamics' -a project='Zubin' -a signedDate=$(date +%Y-%m-%dT%H:%M:%S) 2>&1); then
        echo "--- Signing successful ---"
        cosign verify \
            --key ${uri_value} \
            ${IMAGE_NAME} | jq .
    else
        echo "Error occurred during signing with URI:$uri_value.\n"
    fi
done

cosign save --dir /cosign/data/${IMAGE_NAME} ${IMAGE_NAME}