# syntax = docker/dockerfile:1.2

ARG ALPINE_VERSION=3.12
ARG GO_VERSION=1.16.5

FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS gobase
RUN --mount=target=/root/.cache,type=cache --mount=target=/go/pkg/mod,type=cache \
	set -ex && \
	apk add --no-cache git btrfs-progs-dev musl-dev build-base

FROM gobase AS builder
WORKDIR /host
ENV GOOS=linux
ENV GOARCH=amd64
ENV CGO_ENABLED=1
RUN --mount=target=/host --mount=type=tmpfs,target=./bin --mount=target=/root/.cache,type=cache --mount=target=/go/pkg/mod,type=cache \
	set -ex && \
	make binaries EXTRA_FLAGS="-buildmode pie" \
		EXTRA_LDFLAGS='-extldflags "-static"' \
		BUILDTAGS="netgo osusergo static_build" && \
	mkdir -p /opt/bin && \
	mv /host/bin/* /opt/bin/

FROM scratch AS releaser
COPY --from=builder /opt/bin/* /
