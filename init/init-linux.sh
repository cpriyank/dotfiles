#!/usr/bin/env bash

set -euo pipefail

script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

linux_id=""
linux_id_like=""
if [[ -r /etc/os-release ]]; then
	# shellcheck disable=SC1091
	source /etc/os-release
	linux_id="${ID:-}"
	linux_id_like="${ID_LIKE:-}"
fi

case " ${linux_id} ${linux_id_like} " in
	*" arch "*|*" archlinux "*)
		echo "Detected Arch GNU/Linux..."
		bash "${script_dir}/init-archlinux.sh"
		;;
	*" ubuntu "*|*" debian "*)
		echo "Detected Ubuntu/Debian..."
		bash "${script_dir}/init-ubuntu.sh"
		;;
	*)
		if [[ -x "$(command -v pacman)" ]]; then
			echo "Detected Arch GNU/Linux via pacman..."
			bash "${script_dir}/init-archlinux.sh"
		elif [[ -x "$(command -v apt)" ]]; then
			echo "Detected Ubuntu/Debian via apt..."
			bash "${script_dir}/init-ubuntu.sh"
		else
			echo "Unsupported Linux distribution: ${linux_id:-unknown}" >&2
			exit 1
		fi
		;;
esac
