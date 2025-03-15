helm repo add rubxkube https://rubxkube.github.io/charts/
helm repo update

helm upgrade --install jackett rubxkube/jackett \
  --set common.image.tag=latest \
  --set common.service.type=LoadBalancer \
  --set common.persistence.volumes[0].name="config" \
  --set common.persistence.volumes[0].storageClassName="longhorn" \
  --set common.persistence.volumes[0].size="2Gi" \
  --set common.persistence.volumes[0].containerMount="/config" \
  --set common.persistence.volumes[1].name="downloads" \
  --set common.persistence.volumes[1].storageClassName="longhorn" \
  --set common.persistence.volumes[1].size="5Gi" \
  --set common.persistence.volumes[1].containerMount="/downloads" \
  --set common.variables.nonSecret.TZ="Asia/Ho_Chi_Minh" \
  --set common.variables.nonSecret.AUTO_UPDATE="true" \
  --set common.variables.nonSecret.JACKETT_AUTOMATIC_SEARCH_TIMEOUT="120000" \
  --set common.variables.nonSecret.JACKETT_MANUAL_SEARCH_TIMEOUT="15000" \
  -n media --create-namespace


helm upgrade --install flaresolverr rubxkube/flaresolverr \
  --set common.image.tag=latest \
  --set common.variables.nonSecret.TZ="Asia/Ho_Chi_Minh" \
  --set common.variables.nonSecret.FS_BROWSER_TIMEOUT="30000" \
  -n media --create-namespace