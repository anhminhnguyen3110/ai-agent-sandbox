FROM docker:27-dind

# Install dependencies for microsandbox + KVM/QEMU support
RUN apk add --no-cache curl perl-utils libgcc libstdc++ wget libc6-compat qemu-system-x86_64 && \
    # Install glibc compatibility layer for microsandbox binaries
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-i18n-2.35-r1.apk && \
    apk add --no-cache --force-overwrite glibc-2.35-r1.apk glibc-bin-2.35-r1.apk glibc-i18n-2.35-r1.apk && \
    rm *.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    # Create kvm group (GID will be set via group_add at runtime)
    addgroup -g 1000 kvm 2>/dev/null || true && \
    addgroup root kvm 2>/dev/null || true && \
    # Install microsandbox
    curl -fsSL https://get.microsandbox.dev | sh && \
    # Cleanup
    apk del curl wget

ENV PATH="/root/.local/bin:${PATH}"

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 5555

ENTRYPOINT ["/entrypoint.sh"]

