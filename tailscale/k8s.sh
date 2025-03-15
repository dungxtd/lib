helm repo add tailscale https://pkgs.tailscale.com/helmcharts

helm repo update

helm upgrade \
  --install \
  tailscale-operator \
  tailscale/tailscale-operator \
  --namespace=tailscale \
  --create-namespace \
  --set-string oauth.clientId="<OAauth client ID>" \
  --set-string oauth.clientSecret="<OAuth client secret>" \
  --set-string apiServerProxyConfig.mode="true" \
  --wait
