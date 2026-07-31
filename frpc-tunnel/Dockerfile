ARG BUILD_FROM
FROM ${BUILD_FROM}

# frpc, pinned by version AND sha256 (tamper-evident: a swapped release fails
# the checksum). The base image ARG resolves the right arch per build.
ARG FRP_VERSION=0.70.1
ARG BUILD_ARCH=amd64
ARG FRP_SHA256_amd64=333da23d1b9009d7c01638e9ba38cf4600f7d37d393f854e96ee1396adefa9a6
ARG FRP_SHA256_arm64=3990f396a9a490ee7f0e5f355287750ed41520064ed999eab443b5e9a78d773d
ARG FRP_SHA256_arm=da53c7211ce3ff7b4654e3018185fdd9b4b12143184f622e85653403862f3d3c

# hadolint ignore=DL3018,DL4006
RUN apk add --no-cache curl \
    && case "${BUILD_ARCH}" in \
         amd64)  FRP_ARCH=amd64; FRP_SHA="${FRP_SHA256_amd64}" ;; \
         aarch64) FRP_ARCH=arm64; FRP_SHA="${FRP_SHA256_arm64}" ;; \
         armv7)  FRP_ARCH=arm;   FRP_SHA="${FRP_SHA256_arm}" ;; \
         *) echo "unsupported arch ${BUILD_ARCH}" && exit 1 ;; \
       esac \
    && TARBALL="frp_${FRP_VERSION}_linux_${FRP_ARCH}.tar.gz" \
    && curl -fsSL -o "/tmp/${TARBALL}" "https://github.com/fatedier/frp/releases/download/v${FRP_VERSION}/${TARBALL}" \
    && echo "${FRP_SHA}  /tmp/${TARBALL}" | sha256sum -c - \
    && tar xzf "/tmp/${TARBALL}" -C /tmp \
    && install -m 0755 "/tmp/frp_${FRP_VERSION}_linux_${FRP_ARCH}/frpc" /usr/local/bin/frpc \
    && rm -rf /tmp/frp_* \
    && apk del curl

COPY run.sh /run.sh
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
