# Stage 1: Tải cosign từ GitHub
FROM alpine:latest AS downloader

# Cài đặt curl
RUN apk add --no-cache curl

# Tải tệp cosign
RUN curl -L -o /tmp/cosign https://github.com/sigstore/cosign/releases/latest/download/cosign-linux-pivkey-pkcs11key-amd64

# Stage 2: Sử dụng Ubuntu làm hình ảnh chính
FROM ubuntu:22.04

# Copy cosign binary từ stage downloader
COPY --from=downloader /tmp/cosign /usr/local/bin/cosign

# Đảm bảo cosign binary có thể thực thi
RUN chmod +x /usr/local/bin/cosign

# Cập nhật và cài đặt các thư viện cần thiết
RUN apt-get update && apt-get install -y \
    libtpm2-pkcs11-1 \
    tpm2-tools \
    libengine-pkcs11-openssl \
    opensc \
    jq \
    && rm -rf /var/lib/apt/lists/*

# Thêm chứng chỉ CA vào hệ thống
RUN cat <<EOF > /usr/local/share/ca-certificates/ca.crt
-----BEGIN CERTIFICATE-----
MIIFSTCCAzGgAwIBAgIUXobEAvp4W5JHGNXBTFQB9fW1X+kwDQYJKoZIhvcNAQEL
BQAwIjEgMB4GA1UEAwwXZGRwbGF0Zm9ybS1wdnQtcmVnaXN0cnkwHhcNMjMxMDE3
MDU0NTQ0WhcNMzMxMDE0MDU0NTQ0WjAiMSAwHgYDVQQDDBdkZHBsYXRmb3JtLXB2
dC1yZWdpc3RyeTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBALtb7EyD
8BUxTtFWto+1a6S4VKf1HAOm3LVGR8iFU8sDZRC1KdTrf1GM023D4kjNy5S8wq/8
uLwSGTxC5rmJ5prjYkAbsg6CTJsZ/D0+56Pc9yevtZGD5BCxrVWqhh4viNDaJZ3p
JwAyf5Um9qUucp1kayZfcSbSdR7PC2/uMqP2Fd3baCLkidb5F/a9X3YdUXYPMH9w
LyjwEH3QQqu3oYxq9uI5WaG2yVo0PALElFdl4OLkClQx0fKQ+qLICTD0Wp6FPKbe
GasSD+HLGcFGm94IxrfM2aH5Oq0WQdE7ux2l7Veswnw0R96IiNzQ4BTI3A+AUih/
F5DzcxpgB0PQIMVuUxtPDzPw9WC9TyvWETIKXh03WWMNZpRT5ZTIpPwzFt+gabEJ
CAMdsJAVRJSlEuopEbl0dohG0O1RCzPMW4dZJyVKAIuU6rvvK/EVUAnFOhEXFRkx
0zbZ49yc7xi/h+8MxdeK+B36BBssV4jPAaDEO/rIzlp7qGBCXZymI/kfOXsPCPGM
b/qqVPmtD/MFzqv4N3Hst5ft50OWB/a//Krg+OMNNeJRMALcFJQRWAgcPlA8Uebo
VzWUg5RH9ZxQvZTKTkWRyuZFYyyiRleVrQrlLLDA2wEHzFuPxYKNmGVWcN2MgnT9
ZEgkNWcmy/yU2o/Y93wzJrK/hnxrS8kFyOFLAgMBAAGjdzB1MB0GA1UdDgQWBBQb
LplJUSoUY6zSs9mJQE8Y4TePMzAfBgNVHSMEGDAWgBQbLplJUSoUY6zSs9mJQE8Y
4TePMzAPBgNVHRMBAf8EBTADAQH/MCIGA1UdEQQbMBmCF2RkcGxhdGZvcm0tcHZ0
LXJlZ2lzdHJ5MA0GCSqGSIb3DQEBCwUAA4ICAQBRMIhIny+cClL3vgbuf9Ay5k/N
gZ8kxOEvpwYAcDfJxEqN1hBMCrkRogAXrUAQbA19Xnx5HluEIxyF+KVGiOLlzyr8
YrZPJS8QlHGcmnerrCNAsI1Ls85solNg9wYvN1PPPI6lOofCEb3jftpr2bfq8VER
+rbuXTqOyUr1INBscSlwzVKFgWHQhXXCMv6acZmL9pHau4lYBd23Ntw/ECHUcJ3A
yj1rgl8lpwsK0jOeWwKUXqmrZMW3Sk5zT9JKsKkFVNu0tY/E4kbvbIVhmqstIuLA
k2iGnyoKKLiccoysEkeXkYXz5lL7+3HL4bXLvtjPZBk24elfQu6PdFtsgySyx8QC
dgd23V2ilvAAwwkMQsBuo8TL+g76tMORuFPvcrV7P1X5MdDwCEt2fHd0YV8v6Kqg
CR2OJLJRWKDbNeIhUsEQs275PxnSI5bqifvx2wydBq6Z/gu07iXRXbRQZhQ/RLFV
iu9JX/QtfoHiJ93YtV5PeDu62mbJTT3vGb/nzQLCIHvWqWtU1HQppJpussa2aYrv
HpKOfE0woGEy0+dJKI0CYaCJPDsrrcmKpzEEJfS2ReGLVuxhYqYkqhSdcDwlzSdn
ei5gwMCU3GvUw1/qaDl/CY2lnOiluvb4gQP3Y27gH2f/mxhnJvB4+FrC+rgmho+V
TaomFIP8CKkgq2IbWg==
-----END CERTIFICATE-----
EOF

# Cập nhật chứng chỉ CA
RUN update-ca-certificates