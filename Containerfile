# https://github.com/awesome-containers/static-bash
ARG STATIC_BASH_VERSION=5.2.15

FROM ghcr.io/awesome-containers/alpine-build-essential:3.17 AS build

# http://git.savannah.gnu.org/cgit/coreutils.git/
ARG COREUTILS_VERSION=9.1

WORKDIR /src/coreutils

RUN git clone --branch "v$COREUTILS_VERSION" \
        git://git.savannah.gnu.org/coreutils.git .

ARG FORCE_UNSAFE_CONFIGURE=1
ARG CFLAGS='-ffunction-sections -fdata-sections -w -g -Os -static'
ARG LDFLAGS='-Wl,--gc-sections'

# hadolint ignore=SC2044,DL4006
RUN set -eux; \
    ./bootstrap --skip-po; \
    ./configure; \
    make -j$(nproc); \
    # make distcheck; \
    # make check; \
    mkdir bin; \
    for bin in $(find ./src/ -executable -type f); do \
        file "$bin" -b --mime-type | grep -qw 'application/x-executable' || \
            continue; \
        mv "$bin" bin/; \
    done; \
    # rm 'bin/[' bin/echo bin/false bin/printf bin/pwd bin/test bin/true; \
    chmod -cR 755 bin; \
    chown -cR 0:0 bin

# static coreutils image
FROM ghcr.io/awesome-containers/static-bash:$STATIC_BASH_VERSION
COPY --from=build /src/coreutils/bin/ /bin/
