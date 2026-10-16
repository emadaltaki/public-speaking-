#!/usr/bin/env sh
# Builds the site into build/web (committed; Vercel serves it as-is).
# Offline caching is off: it served stale versions after deploys. The
# placeholder worker removes the old cache from browsers that still have it.
# --wasm renders much faster on phones; browsers without WebAssembly GC fall
# back to the JavaScript build automatically. Multi-threaded rendering needs
# the cross-origin isolation headers set in web/vercel.json.
set -e
cd "$(dirname "$0")/.."
flutter build web --release --wasm --pwa-strategy=none
cp tool/flutter_service_worker.js build/web/flutter_service_worker.js
