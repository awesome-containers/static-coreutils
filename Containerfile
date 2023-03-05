# https://github.com/awesome-containers/static-bash
ARG STATIC_BASH_VERSION=5.2.15
ARG STATIC_BASH_IMAGE=ghcr.io/awesome-containers/static-bash

# https://github.com/awesome-containers/alpine-build-essential
ARG BUILD_ESSENTIAL_VERSION=3.17
ARG BUILD_ESSENTIAL_IMAGE=ghcr.io/awesome-containers/alpine-build-essential


FROM $STATIC_BASH_IMAGE:$STATIC_BASH_VERSION AS static-bash
FROM $BUILD_ESSENTIAL_IMAGE:$BUILD_ESSENTIAL_VERSION AS build

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
    make -j"$(nproc)"; \
    # make distcheck; \
    # make check; \
    mkdir bin; \
    for bin in $(find ./src/ -executable -type f); do \
        file "$bin" -b --mime-type | grep -qw 'application/x-executable' || \
            continue; \
        ! ldd "$bin" && :; \
        strip -s -R .comment --strip-unneeded "$bin"; \
        mv "$bin" bin/; \
    done; \
    # rm 'bin/[' bin/echo bin/false bin/printf bin/pwd bin/test bin/true; \
    chmod -cR 755 bin; \
    chown -cR 0:0 bin; \
    ./bin/cp --version; \
    printf '%s\n' 'root:x:0:0:root:/:/bin/bash' \
        'nobody:x:65534:65534:nobody:/:/bin/false' > ../passwd; \
    printf '%s\n' 'nogroup:x:65534:' 'root:x:0:' > ../group

# static coreutils image
FROM static-bash
COPY --from=build /src/passwd /src/group /etc/
COPY --from=build /src/coreutils/bin/ /bin/
