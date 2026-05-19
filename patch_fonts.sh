#!/bin/bash
# Patch: Remove Google fonts and external font CDN dependencies
# - Replace web fonts (Clash Display, Geist Sans, Geist Mono) with system font stacks
# - Remove external font CDN links (fonts.googleapis.com, fonts.gstatic.com, fontshare.com, jsdelivr Geist)
# - Disable Google font providers in Nuxt fonts module

REPO_ROOT="$(cd "$(dirname "$0")" && pwd)"

# --- app/assets/css/main.css ---
# Replace custom web font references with system font stacks
sed -i 's|--font-display: "Clash Display", "Geist Sans", system-ui, sans-serif;|--font-display: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;|' \
  "$REPO_ROOT/app/assets/css/main.css"

sed -i 's|--font-sans: "Geist Sans", "Geist", system-ui, sans-serif;|--font-sans: system-ui, -apple-system, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;|' \
  "$REPO_ROOT/app/assets/css/main.css"

sed -i 's|--font-mono: "Geist Mono", "SF Mono", ui-monospace, monospace;|--font-mono: ui-monospace, SFMono-Regular, "SF Mono", Menlo, Consolas, "Liberation Mono", monospace;|' \
  "$REPO_ROOT/app/assets/css/main.css"

# --- nuxt.config.ts ---
# Remove external font CDN link entries
sed -i "/rel: 'preconnect', href: 'https:\/\/fonts.googleapis.com'/d" \
  "$REPO_ROOT/nuxt.config.ts"

sed -i "/rel: 'preconnect', href: 'https:\/\/fonts.gstatic.com'/d" \
  "$REPO_ROOT/nuxt.config.ts"

sed -i "/rel: 'stylesheet', href: 'https:\/\/api.fontshare.com/d" \
  "$REPO_ROOT/nuxt.config.ts"

sed -i "/rel: 'stylesheet', href: 'https:\/\/cdn.jsdelivr.net\/npm\/@fontsource\/geist-sans/d" \
  "$REPO_ROOT/nuxt.config.ts"

sed -i "/rel: 'stylesheet', href: 'https:\/\/cdn.jsdelivr.net\/npm\/@fontsource\/geist-mono/d" \
  "$REPO_ROOT/nuxt.config.ts"

# Add fonts config block to disable Google providers (after colorMode block)
sed -i '/^  colorMode: {$/,/^  },$/ {
  /^  },$/a\
\
  fonts: {\
    providers: {\
      google: false,\
      googleicons: false,\
    },\
  },
}' "$REPO_ROOT/nuxt.config.ts"

echo "Patch applied: Google fonts removed, system fonts substituted."
