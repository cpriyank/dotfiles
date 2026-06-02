#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"

sed -i '' "s|{{HOME_MANAGER_USERNAME}}|$USER|g" "$DIR/flake.nix" "$DIR/home.nix"
sed -i '' "s|{{HOME_MANAGER_HOME_DIRECTORY}}|$HOME|g" "$DIR/home.nix"

echo "Configured for user '$USER' with home '$HOME'"
