
cosign load --dir ${PATH_COSIGN_DATA}/${IMAGE_NAME} ${TARGET_IMAGE_NAME} 
cosign pkcs11-tool list-keys-uris --module-path ${PATH_COSIGN_LIB}/libp11.so --slot-id 0 --pin anything | grep "pkcs11:token=" | while read -r line; do
    # Extract the part after "URI:" and trim the whitespace
    uri_value=$(echo "$line" | cut -d ':' -f 2- | awk '{$1=$1; print}')    
    # Extract the key label from the URI
    label=$(echo "$uri_value" | grep -oP '(?<=object=key_)\d+')
    
    echo "Verifying with key $label..." 
    # Attempt to sign and catch errors
    if output=$(cosign verify --key ${uri_value} ${TARGET_IMAGE_NAME} 2>&1); then
        echo "${output}"
    else
        echo "--- Verifying error ---"
    fi
done