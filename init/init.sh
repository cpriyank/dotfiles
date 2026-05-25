#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
    Linux) bash "${script_dir}/init-linux.sh" ;;
    FreeBSD) bash "${script_dir}/init-freebsd.sh" ;;
    Darwin) bash "${script_dir}/init-darwin.sh" ;;
    *)
        echo "Unsupported OS: $(uname -s)" >&2
        exit 1
        ;;
esac
