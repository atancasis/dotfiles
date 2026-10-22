#!/bin/bash

# Start Mouseless and Hammerspoon at login, unless they are login items
# already, and start them now.

set -euo pipefail

for app in Mouseless Hammerspoon; do
  osascript -e "tell application \"System Events\" to if not (exists login item \"$app\") then make login item at end with properties {path:\"/Applications/$app.app\", hidden:false}" >/dev/null
  open -g -a "$app"
done
