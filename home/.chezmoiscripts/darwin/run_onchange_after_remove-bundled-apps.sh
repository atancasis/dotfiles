#!/bin/bash

# Remove the apps Apple bundles that this setup doesn't use. All are free in the
# App Store. This runs again only when the list changes, so an app reinstalled
# on purpose stays.

set -euo pipefail

unwanted=(
  com.apple.garageband10
  com.apple.iMovieApp
  com.apple.Keynote
  com.apple.Numbers
  com.apple.Pages
)

# Logic Pro and MainStage share GarageBand's sound library.
keep_library=
for app in /Applications/*.app; do
  id=$(defaults read "$app/Contents/Info" CFBundleIdentifier 2>/dev/null || true)
  case $id in
    com.apple.logic10 | com.apple.mainstage3) keep_library=1 ;;
  esac
  for unwanted_id in "${unwanted[@]}"; do
    if [[ $id == "$unwanted_id" ]]; then
      echo "Removing ${app##*/}"
      sudo rm -rf "$app"
    fi
  done
done

if [[ -z $keep_library ]]; then
  sudo rm -rf "/Library/Application Support/GarageBand" \
    "/Library/Application Support/Logic" \
    "/Library/Audio/Apple Loops/Apple"
fi
