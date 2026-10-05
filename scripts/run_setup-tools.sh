#!/usr/bin/env bash

echo "Tools installation..."

set -e

if [ "$OSTYPE" != "linux-gnu" ]; then
    echo "Aborting... os type is $OSTYPE"
    exit 0
fi

if [ -z "${XDG_CONFIG_HOME+x}" ]; then
    echo "XDG_CONFIG_HOME not set... aborting"
    exit 0
fi

for cmd in curl git unzip tar sha256sum cut basename; do
    if ! command -v "$cmd" &> /dev/null; then
        echo "Error: Required system tool '$cmd' is not installed." >&2
        exit 1
    fi
done

INSTALL_DIR="$HOME/.local/bin"

mkdir -p "$INSTALL_DIR"

#################
# FZF
#################

if [ ! -d "$INSTALL_DIR/fzf.d" ]; then
    echo -n "Installing FZF ... "
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/junegunn/fzf "$INSTALL_DIR/fzf.d"
    "$INSTALL_DIR/fzf.d/install" --all --xdg --no-update-rc
    echo "DONE"
fi

#################
# AWS CLI
#################

AWS_URL=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

if [ ! -f "$INSTALL_DIR/aws" ]; then
    echo -n "Installing AWS CLI v2 ... "
    rm -rf "$INSTALL_DIR/aws-cli"
    TEMP_DIR=$(mktemp -d)
    curl -o "$TEMP_DIR/awscli.zip" -sL "$AWS_URL"
    unzip -qq "$TEMP_DIR/awscli.zip" -d "$TEMP_DIR"
    "$TEMP_DIR//aws/install" -u -i "$INSTALL_DIR/aws-cli" -b "$INSTALL_DIR" > /dev/null
    rm -rf "$TEMP_DIR"
    echo "DONE"
fi

#################
# FD
#################

FD_VERSION=v10.5.0
FD_SHA256=a1259cd129636efbc3fef123525c1b49e88fe5088c012630983c310e52fdfa95
FD_URL="https://github.com/sharkdp/fd/releases/download/$FD_VERSION/fd-$FD_VERSION-x86_64-unknown-linux-gnu.tar.gz"

if [ ! -d "$INSTALL_DIR/fd.d" ]; then
    echo -n "Installing FD ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/fd.tar.gz -sL "$FD_URL"
    echo "$FD_SHA256 ""${TEMP_DIR}""/fd.tar.gz" | sha256sum -c --quiet
    mkdir -p "$INSTALL_DIR/fd.d"
    tar -C "$INSTALL_DIR/fd.d" --strip-components=1 -xf "${TEMP_DIR}"/fd.tar.gz
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

ln -sf "$INSTALL_DIR/fd.d/fd" "$INSTALL_DIR/fd"

#################
# HADOLINT
#################

HADOLINT_VERSION=v2.15.1
HADOLINT_URL="https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-linux-x86_64"
HADOLINT_SHA256="c7187db94eeeeca956519a6af171adc31453941a1e777961f6e680f697c8c507"

if [ ! -f "$INSTALL_DIR/hadolint" ]; then
    echo -n "Installing HADOLINT ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/hadolint -sL "$HADOLINT_URL"
    echo "$HADOLINT_SHA256 ""${TEMP_DIR}""/hadolint" | sha256sum -c --quiet
    mv "${TEMP_DIR}"/hadolint "$INSTALL_DIR"
    chmod +x "$INSTALL_DIR/hadolint"
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

#################
# HELM
#################

HELM_VERSION=v3.22.0
HELM_URL="https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz"
HELM_CHECKSUM_URL="https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz.sha256sum"

if [ ! -f "$INSTALL_DIR/helm" ]; then
    echo -n "Installing HELM ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/helm.tar.gz -sL "$HELM_URL"
    curl -o "${TEMP_DIR}"/helm.sha256sum -sL "$HELM_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/helm.sha256sum) ""${TEMP_DIR}""/helm.tar.gz" | sha256sum -c --quiet
    tar -C "$INSTALL_DIR" --strip-components=1 -xzf """${TEMP_DIR}""/helm.tar.gz" linux-amd64/helm
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

#################
# KUBECTL
#################

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
KUBECTL_URL="https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
KUBECTL_CHECKSUM_URL="https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256"

if [ ! -f "$INSTALL_DIR/kubectl" ]; then
    echo -n "Installing KUBECTL ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/kubectl -sL "$KUBECTL_URL"
    curl -o "${TEMP_DIR}"/kubectl.sha256sum -sL "$KUBECTL_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/kubectl.sha256sum) ""${TEMP_DIR}""/kubectl" | sha256sum -c --quiet
    mv "${TEMP_DIR}"/kubectl "$INSTALL_DIR"
    chmod +x "$INSTALL_DIR/kubectl"
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

#################
# RIPGREP
#################

RG_VERSION=15.2.0
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz"
RG_CHECKSUM_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz.sha256"

if [ ! -d "$INSTALL_DIR/ripgrep" ]; then
    echo -n "Installing RG ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/rg.tar.gz -sL "$RG_URL"
    curl -o "${TEMP_DIR}"/rg.tar.gz.sha256sum -sL "$RG_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/rg.tar.gz.sha256sum) ""${TEMP_DIR}""/rg.tar.gz" | sha256sum -c --quiet
    mkdir -p "$INSTALL_DIR/ripgrep"
    tar -C "$INSTALL_DIR/ripgrep" --strip-components=1 -xf "${TEMP_DIR}"/rg.tar.gz
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

ln -sf "$INSTALL_DIR/ripgrep/rg" "$INSTALL_DIR/rg"

#################
# SDKMAN
#################

if [ ! -d "$INSTALL_DIR/sdkman" ]; then
    echo -n "Installing SDKMAN ... "
    export SDKMAN_DIR="$INSTALL_DIR/sdkman" \
        && curl -s "https://get.sdkman.io?rcupdate=false" | bash > /dev/null 2>&1
    echo "DONE"
fi

#################
# NEOVIM
#################

NVIM_VERSION=v0.12.5
NVIM_URL="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux-x86_64.tar.gz"

if [ ! -d "$INSTALL_DIR/neovim" ]; then
    echo -n "Installing NEOVIM... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/nvim.tar.gz -L "$NVIM_URL"
    mkdir -p "$INSTALL_DIR/neovim"
    tar -C "$INSTALL_DIR/neovim" --strip-components=1 -xf "${TEMP_DIR}"/nvim.tar.gz
    echo "DONE"
fi

ln -sf "$INSTALL_DIR/neovim/bin/nvim" "$INSTALL_DIR/nvim"

#################
# SHELLCHECK
#################

SC_VERSION=v0.11.0
SC_SHA256=8c3be12b05d5c177a04c29e3c78ce89ac86f1595681cab149b65b97c4e227198
SC_URL="https://github.com/koalaman/shellcheck/releases/download/$SC_VERSION/shellcheck-$SC_VERSION.linux.x86_64.tar.xz"

if [ ! -f "$INSTALL_DIR/shellcheck" ]; then
    echo -n "Installing SC ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/sc.tar.xz -sL "$SC_URL"
    echo "$SC_SHA256 ""${TEMP_DIR}""/sc.tar.xz" | sha256sum -c --quiet
    tar -C "$INSTALL_DIR" --strip-components=1 -xf """${TEMP_DIR}""/sc.tar.xz" "shellcheck-$SC_VERSION/shellcheck"
    rm "${TEMP_DIR}"/sc.tar.xz
    echo "DONE"
fi

#################
# LAZYGIT
#################

LAZYGIT_VERSION=0.65.1
LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
LAZYGIT_FILE=$(basename $LAZYGIT_URL)
LAZYGIT_SHA256=02beacbcda0fa342e50ae3480ba8147307353af3fb28e1d5f790e02329c201a6

if [ ! -f "$INSTALL_DIR/lazygit" ]; then
    echo -n "Installing LAZYGIT... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/"$LAZYGIT_FILE" -sL "$LAZYGIT_URL"
    echo "$LAZYGIT_SHA256 ""${TEMP_DIR}""/$LAZYGIT_FILE" | sha256sum -c --quiet
    mkdir -p "$INSTALL_DIR/lazygit"
    tar -C "$INSTALL_DIR" -xf "${TEMP_DIR}"/"$LAZYGIT_FILE" lazygit
    rm "${TEMP_DIR}"/"$LAZYGIT_FILE"
    echo "DONE"
fi

#################
# SHFMT
#################
SHFMT_VERSION=3.14.1
SHFMT_URL="https://github.com/mvdan/sh/releases/download/v${SHFMT_VERSION}/shfmt_v${SHFMT_VERSION}_linux_amd64"
SHFMT_FILE=$(basename $SHFMT_URL)
SHFMT_SHA256=76e77641faa025814b77f153b29796b8e6fa2fca03e0c76a691608b86c7ea7bf

if [ ! -f "$INSTALL_DIR/shfmt" ]; then
    echo -n "Installing SHFMT... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/"$SHFMT_FILE" -sL "$SHFMT_URL"
    echo "$SHFMT_SHA256 ""${TEMP_DIR}""/$SHFMT_FILE" | sha256sum -c --quiet
    mv "${TEMP_DIR}"/"$SHFMT_FILE" "$INSTALL_DIR/shfmt"
    echo "DONE"
fi

echo "DONE"
