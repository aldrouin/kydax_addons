ARG BUILD_FROM
FROM ${BUILD_FROM}

# frpc, pinned. The base image ARG resolves the right arch per build.
ARG FRP_VERSION=0.70.1
ARG BUILD_ARCH=amd64

RUN apk add --no-cache curl \
    && case "${BUILD_ARCH}" in \
         amd64) FRP_ARCH=amd64 ;; \
         aarch64) FRP_ARCH=arm64 ;; \
         armv7) FRP_ARCH=arm ;; \
         *) echo "unsupported arch ${BUILD_ARCH}" && exit 1 ;; \
       esac \
    && curl -fsSL "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/frp_${FRP_VERSION}_linux_${FRP_ARCH}.tar.gz" \
       | tar xz -C /tmp \
    && install -m 0755 "/tmp/frp_${FRP_VERSION}_linux_${FRP_ARCH}/frpc" /usr/local/bin/frpc \
    && rm -rf /tmp/frp_* \
    && apk del curl

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
