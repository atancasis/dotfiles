#!/bin/bash

# Start Mouseless at login, unless it is a login item already.

set -euo pipefail

osascript -e 'tell application "System Events" to if not (exists login item "Mouseless") then make login item at end with properties {path:"/Applications/Mouseless.app", hidden:false}' >/dev/null
