#!/usr/bin/env bash

set -euo pipefail

[[ $OSTYPE == linux* ]] || { echo "Aborting... os type is $OSTYPE" >&2; exit 1; }
[[ $(uname -m) == x86_64 ]] || { echo "Aborting... unsupported arch $(uname -m)" >&2; exit 1; }

for cmd in curl zip unzip tar sha256sum python3; do
    command -v "$cmd" >/dev/null || { echo "Error: Required system tool '$cmd' is not installed." >&2; exit 1; }
done


###############################################################################
# install_tool NAME URL SHA256 [STRIP]
#
# Download, verify, and install a tool into "$APP_INSTALL_DIR/NAME".
#
# Arguments:
#   NAME    Tool name; also the install subdirectory name.
#   URL     Download URL. The extension (query/fragment ignored) selects how
#           it is installed:
#             *.zip           extracted as-is (STRIP is ignored)
#             *.tar.*, *.tgz  extracted with STRIP leading path components removed
#             other           treated as a single binary, saved as NAME and made
#                             executable
#   SHA256  Expected SHA-256 checksum of the downloaded file.
#   STRIP   Optional. Leading path components to strip from tar.* or tgz
#           archives (default: 1).
#
# Globals:
#   APP_INSTALL_DIR  Required. Parent directory for installed tools.
#
# Returns:
#   0 on success or if already installed; 1 on installation failure.
#
###############################################################################
install_tool() {
    local name=$1 url=$2 sha256=$3 strip=${4:-1}
    local marker="$APP_INSTALL_DIR/.installed/$name"

    if [[ -f "$marker" && -d "$APP_INSTALL_DIR/$name" && "$url $sha256" == "$(< "$marker")" ]]; then
        echo "✔ $name: already installed"
        return 0
    fi

    echo "… $name: installing"

    local temp_dir
    temp_dir=$(mktemp -d -p "$APP_INSTALL_DIR") || return 1
    trap 'rm -rf "$temp_dir"; trap - RETURN' RETURN

    curl -o "$temp_dir/archive" --retry 3 -fsSL "$url" || {
        echo "⚠ failed to download $name" >&2
        return 1
    }

    echo "$sha256  $temp_dir/archive" | sha256sum -c --quiet - || {
        echo "⚠ checksum mismatch for $name" >&2
        return 1
    }

    local stage_dir="$temp_dir/out"
    mkdir -p "$stage_dir"

    case "${url%%[?#]*}" in
        *.zip)
            # NOTE: we're ignoring the strip argument for zips
            unzip -q "$temp_dir/archive" -d "$stage_dir"
            ;;
        *.tar.*|*.tgz)
            tar -C "$stage_dir" --strip-components="$strip" -xf "$temp_dir/archive"
            ;;
        *)
            mv "$temp_dir/archive" "$stage_dir/$name" \
                && chmod +x "$stage_dir/$name"
            ;;
    esac || {
        echo "⚠ failed to install $name" >&2
        return 1
    }

    rm -rf "$APP_INSTALL_DIR/${name:?}"

    mv "$stage_dir" "$APP_INSTALL_DIR/$name" || {
        echo "⚠ failed to install $name" >&2
        return 1
    }

    echo "$url $sha256" > "$marker"

    echo "✔ $name: installed"
}

BOLD=$'\e[1m' RESET=$'\e[0m'
printf '%sTools installation...%s\n' "$BOLD" "$RESET"

BIN_DIR="$HOME/.local/bin"
APP_INSTALL_DIR="$HOME/.local/opt"

mkdir -p "$BIN_DIR" "$APP_INSTALL_DIR" "$APP_INSTALL_DIR/.installed"

trap 'rm -rf "$APP_INSTALL_DIR"/tmp.*' EXIT

###############################################################################
# FD
###############################################################################
install_tool fd \
    'https://github.com/sharkdp/fd/releases/download/v10.5.0/fd-v10.5.0-x86_64-unknown-linux-gnu.tar.gz' \
    'a1259cd129636efbc3fef123525c1b49e88fe5088c012630983c310e52fdfa95'
ln -sf "$APP_INSTALL_DIR/fd/fd" "$BIN_DIR/fd"

###############################################################################
# RIPGREP
###############################################################################
install_tool rg \
    'https://github.com/BurntSushi/ripgrep/releases/download/15.2.0/ripgrep-15.2.0-x86_64-unknown-linux-musl.tar.gz' \
    '33e15bcf1624b25cdd2a55813a47a2f95dbe126268203e76aa6a585d1e7b149c'
ln -sf "$APP_INSTALL_DIR/rg/rg" "$BIN_DIR/rg"

###############################################################################
# NEOVIM
###############################################################################
install_tool nvim \
    'https://github.com/neovim/neovim/releases/download/v0.12.6/nvim-linux-x86_64.tar.gz' \
    '474430d53e6264f6d6dd18db42d6dc9df3a1b56ca9e88a325bbf860e1a811d87'
ln -sf "$APP_INSTALL_DIR/nvim/bin/nvim" "$BIN_DIR/nvim"

###############################################################################
# FZF
###############################################################################
install_tool fzf \
    'https://github.com/junegunn/fzf/releases/download/v0.74.5/fzf-0.74.5-linux_amd64.tar.gz' \
    'd47d7f882972c7d674dbbba998ffa4116e68379616ffac7695d0671e9a722c5f' 0
ln -sf "$APP_INSTALL_DIR/fzf/fzf" "$BIN_DIR/fzf"

###############################################################################
# FNM
###############################################################################
install_tool fnm \
    'https://github.com/Schniz/fnm/releases/download/v1.39.0/fnm-linux.zip' \
    '7807664f39d39fc518da1c35ba0181e4b3267603c4b1dedeb4b5fc6ae440a224'
chmod +x "$APP_INSTALL_DIR/fnm/fnm"
ln -sf "$APP_INSTALL_DIR/fnm/fnm" "$BIN_DIR/fnm"

###############################################################################
# STARSHIP
###############################################################################
install_tool starship \
    'https://github.com/starship/starship/releases/download/v1.27.0/starship-x86_64-unknown-linux-gnu.tar.gz' \
    '3b94758850901717eb36aa1b53f8492c1322506ec6d41273bc6151e79ed8e4a1' 0
ln -sf "$APP_INSTALL_DIR/starship/starship" "$BIN_DIR/starship"

###############################################################################
# ZOXIDE
###############################################################################
install_tool zoxide \
    'https://github.com/ajeetdsouza/zoxide/releases/download/v0.10.0/zoxide-0.10.0-x86_64-unknown-linux-musl.tar.gz' \
    '2d93385b99f3e82cf2701609a1bffcad863fbeb75aa3fe7eb6be4d29be68b1ae' 0
ln -sf "$APP_INSTALL_DIR/zoxide/zoxide" "$BIN_DIR/zoxide"

###############################################################################
# SDKMAN
###############################################################################
if [ ! -f "$APP_INSTALL_DIR/sdkman/bin/sdkman-init.sh" ]; then
    echo "… sdkman: installing"
    rm -rf "$APP_INSTALL_DIR/sdkman"
    export SDKMAN_DIR="$APP_INSTALL_DIR/sdkman"
    # NOTE: unpinned upstream installer (not checksum-verified)
    curl -fsSL "https://get.sdkman.io?ci=true&rcupdate=false" | bash >/dev/null || {
        echo "⚠ failed to install sdkman" >&2
        exit 1
    }
    echo "✔ sdkman: installed"
else
    echo "✔ sdkman: already installed"
fi

###############################################################################
# PIPX
###############################################################################
if [ ! -x "$HOME/.local/venv/bin/pipx" ]; then
    echo "… pipx: installing"
    rm -rf "$HOME/.local/venv"
    python3 -m venv "$HOME/.local/venv" || {
        echo "⚠ failed to create python venv" >&2
        exit 1
    }
    "$HOME/.local/venv/bin/pip" install -q pipx==1.18.11 || {
        echo "⚠ failed to install pipx" >&2
        exit 1
    }
    echo "✔ pipx: installed"
else
    echo "✔ pipx: already installed"
fi

ln -sf "$HOME/.local/venv/bin/pipx" "$BIN_DIR/pipx"

[[ ":$PATH:" == *":$BIN_DIR:"* ]] || echo "Note: add $BIN_DIR to your PATH"
