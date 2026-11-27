#!/usr/bin/env bash
# Vercel's build image ships an old Hugo and no Go, so install both here.
set -euo pipefail

GO_VERSION=1.24.7
HUGO_VERSION=0.162.0
TOOLS="${TMPDIR:-/tmp}/cv-tools"

mkdir -p "$TOOLS"
if [ ! -x "$TOOLS/go/bin/go" ]; then
  curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C "$TOOLS" -xz
fi
if [ ! -x "$TOOLS/hugo" ]; then
  curl -fsSL "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz" | tar -C "$TOOLS" -xz hugo
fi

export PATH="$TOOLS/go/bin:$TOOLS:$PATH"
export GOCACHE="$TOOLS/gocache" GOPATH="$TOOLS/gopath" HUGO_CACHEDIR="$TOOLS/hugocache"

hugo version
hugo --gc --minify
pnpm run pagefind
