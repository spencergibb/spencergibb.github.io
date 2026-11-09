#!/bin/sh
set -eu

if command -v portless >/dev/null 2>&1; then
    exec portless gibbtech sh -c '
        exec hugo server --buildDrafts --buildFuture --watch \
            --port "$PORT" --baseURL "$PORTLESS_URL" \
            --appendPort=false --liveReloadPort 443
    '
fi

exec hugo server --buildDrafts --buildFuture --watch
