FROM alpine:3.21

# Install Docker client only (not daemon) + dependencies for microsandbox
RUN apk add --no-cache docker-cli curl perl-utils libgcc libstdc++ wget libc6-compat && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-2.35-r1.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-bin-2.35-r1.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r1/glibc-i18n-2.35-r1.apk && \
    apk add --no-cache --force-overwrite glibc-2.35-r1.apk glibc-bin-2.35-r1.apk glibc-i18n-2.35-r1.apk && \
    rm *.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    curl -fsSL https://get.microsandbox.dev | sh && \
    apk del curl wget

# Add microsandbox to PATH
ENV PATH="/root/.local/bin:${PATH}"

# Expose port
EXPOSE 5555

# Start microsandbox server directly (uses host Docker via mounted socket)
CMD ["/root/.local/bin/msb", "server", "start", "--dev", "--host", "0.0.0.0"]

