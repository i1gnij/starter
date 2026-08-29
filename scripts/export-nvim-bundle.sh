#!/usr/bin/env bash
# Run on a machine that CAN reach GitHub, AFTER Neovim has installed plugins:
#   NVIM_ONLINE=1 nvim --headless "+Lazy! sync" "+TSInstall bash python lua vim vimdoc query json yaml markdown markdown_inline regex" +qa
# Then:
#   ./scripts/export-nvim-bundle.sh /tmp/nvim-airgap.tar.gz
set -euo pipefail

out=${1:-./nvim-airgap-bundle.tar.gz}
config_dir=${NVIM_CONFIG_DIR:-${XDG_CONFIG_HOME:-$HOME/.config}/nvim}
data_dir=${NVIM_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/nvim}

if [[ ! -d $config_dir ]]; then
  echo "missing config dir: $config_dir" >&2
  exit 1
fi
if [[ ! -d $data_dir/lazy ]]; then
  echo "missing plugin dir: $data_dir/lazy  (run NVIM_ONLINE=1 nvim and :Lazy sync first)" >&2
  exit 1
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

mkdir -p "$tmp/bundle"
cp -a "$config_dir" "$tmp/bundle/config"
mkdir -p "$tmp/bundle/data"
cp -a "$data_dir/lazy" "$tmp/bundle/data/lazy"
if [[ -d $data_dir/mason ]]; then
  cp -a "$data_dir/mason" "$tmp/bundle/data/mason"
fi
if [[ -f $config_dir/lazy-lock.json ]]; then
  cp -a "$config_dir/lazy-lock.json" "$tmp/bundle/config/lazy-lock.json"
fi

tar -C "$tmp" -czf "$out" bundle
echo "wrote $out"
echo "On the server unpack to:"
echo "  config -> $config_dir"
echo "  data/lazy -> $data_dir/lazy"
echo "  data/mason -> $data_dir/mason   (optional)"
echo "Put tools on PATH: ruff, shfmt, shellcheck, optionally basedpyright-langserver"
