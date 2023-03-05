# Statically linked Coreutils

Statically linked [Coreutils] container image with [Bash]

> ~ 9,5M (1,1M bash)

```bash
ghcr.io/awesome-containers/static-coreutils:latest
ghcr.io/awesome-containers/static-coreutils:9.1

docker.io/awesomecontainers/static-coreutils:latest
docker.io/awesomecontainers/static-coreutils:9.1
```

Slim statically linked [Coreutils] container image with [Bash]
packaged with [UPX]

Also removed `[`, `echo`, `false`, `printf`, `pwd`, `test` and `true`
because bash has them

> ~ 5M (578K bash)

```bash
ghcr.io/awesome-containers/static-coreutils:latest-slim
ghcr.io/awesome-containers/static-coreutils:9.1-slim

docker.io/awesomecontainers/static-coreutils:latest-slim
docker.io/awesomecontainers/static-coreutils:9.1-slim
```

[Coreutils]: https://www.gnu.org/software/coreutils/
[Bash]: https://github.com/awesome-containers/static-bash
[UPX]: https://upx.github.io/

<!--
```bash
image="localhost/${PWD##*/}"

podman build -t "$image:latest" .
podman build -t "$image:latest-slim" -f Containerfile-slim \
  --build-arg STATIC_COREUTILS_IMAGE="$image" \
  --build-arg STATIC_COREUTILS_VERSION=latest .

echo "$image:latest"
podman inspect "$image:latest" | jq '.[].Size' | numfmt --to=iec
echo "$image:latest-slim"
podman inspect "$image:latest-slim" | jq '.[].Size' | numfmt --to=iec

```
-->
