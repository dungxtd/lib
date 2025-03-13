helm install -f postgresdb.yaml postgresdb oci://registry-1.docker.io/bitnamicharts/postgresql
helm install -f redis.yaml redis oci://registry-1.docker.io/bitnamicharts/redis 
helm install -f n8n.yaml n8n oci://8gears.container-registry.com/library/n8n  --version 0.25.0
