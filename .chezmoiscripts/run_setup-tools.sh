#!/usr/bin/env bash

echo "Tools installation..."

set -e

if [ "$OSTYPE" != "linux-gnu" ]; then
    echo "Aborting... os type is $OSTYPE"
    exit 0
fi

#################
# FZF
#################

if [ ! -d "$HOME/bin/fzf.d" ]; then
    echo -n "Installing FZF ... "
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/junegunn/fzf "$HOME/bin/fzf.d"
    "$HOME/bin/fzf.d/install" --all --xdg --no-update-rc
    echo "DONE"
fi

#################
# AWS CLI
#################

AWS_URL=https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip

if [ ! -f "$HOME/bin/aws" ]; then
    echo -n "Installing AWS CLI v2 ... "
    rm -rf "$HOME/bin/aws-cli"
    TEMP_DIR=$(mktemp -d)
    curl -o "$TEMP_DIR/awscli.zip" -sL "$AWS_URL"
    unzip -qq "$TEMP_DIR/awscli.zip" -d "$TEMP_DIR"
    "$TEMP_DIR//aws/install" -u -i "$HOME/bin/aws-cli" -b "$HOME/bin" > /dev/null
    rm -rf "$TEMP_DIR"
    echo "DONE"
fi

#################
# FD
#################

FD_VERSION=v9.0.0
FD_SHA256=a92f77c76bca0db49810ed2333332356a2b7c6f6f19e842373e6ecfd4c180a67
FD_URL="https://github.com/sharkdp/fd/releases/download/$FD_VERSION/fd-$FD_VERSION-x86_64-unknown-linux-gnu.tar.gz"

if [ ! -d "$HOME/bin/fd.d" ]; then
    echo -n "Installing FD ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/fd.tar.gz -sL "$FD_URL"
    echo "$FD_SHA256 ""${TEMP_DIR}""/fd.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/fd.d"
    tar -C "$HOME/bin/fd.d" --strip-components=1 -xf "${TEMP_DIR}"/fd.tar.gz
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

ln -sf "$HOME/bin/fd.d/fd" "$HOME/bin/fd"

#################
# HADOLINT
#################

HADOLINT_VERSION=v2.12.0
HADOLINT_URL="https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-Linux-x86_64"
HADOLINT_CHECKSUM_URL="https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-Linux-x86_64.sha256"

if [ ! -f "$HOME/bin/hadolint" ]; then
    echo -n "Installing HADOLINT ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/hadolint -sL "$HADOLINT_URL"
    curl -o "${TEMP_DIR}"/hadolint.sha256sum -sL "$HADOLINT_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/hadolint.sha256sum) ""${TEMP_DIR}""/hadolint" | sha256sum -c --quiet
    mv "${TEMP_DIR}"/hadolint "$HOME/bin"
    chmod +x "$HOME/bin/hadolint"
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

#################
# HELM
#################

HELM_VERSION=v3.14.4
HELM_URL="https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz"
HELM_CHECKSUM_URL="https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz.sha256sum"

if [ ! -f "$HOME/bin/helm" ]; then
    echo -n "Installing HELM ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/helm.tar.gz -sL "$HELM_URL"
    curl -o "${TEMP_DIR}"/helm.sha256sum -sL "$HELM_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/helm.sha256sum) ""${TEMP_DIR}""/helm.tar.gz" | sha256sum -c --quiet
    tar -C "$HOME/bin" --strip-components=1 -xzf """${TEMP_DIR}""/helm.tar.gz" linux-amd64/helm
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

#################
# KUBECTL
#################

KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt)
KUBECTL_URL="https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
KUBECTL_CHECKSUM_URL="https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256"

if [ ! -f "$HOME/bin/kubectl" ]; then
    echo -n "Installing KUBECTL ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/kubectl -sL "$KUBECTL_URL"
    curl -o "${TEMP_DIR}"/kubectl.sha256sum -sL "$KUBECTL_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/kubectl.sha256sum) ""${TEMP_DIR}""/kubectl" | sha256sum -c --quiet
    mv "${TEMP_DIR}"/kubectl "$HOME/bin"
    chmod +x "$HOME/bin/kubectl"
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

#################
# RIPGREP
#################

RG_VERSION=14.1.0
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz"
RG_CHECKSUM_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz.sha256"

if [ ! -d "$HOME/bin/ripgrep" ]; then
    echo -n "Installing RG ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/rg.tar.gz -sL "$RG_URL"
    curl -o "${TEMP_DIR}"/rg.tar.gz.sha256sum -sL "$RG_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/rg.tar.gz.sha256sum) ""${TEMP_DIR}""/rg.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/ripgrep"
    tar -C "$HOME/bin/ripgrep" --strip-components=1 -xf "${TEMP_DIR}"/rg.tar.gz
    rm -rf "${TEMP_DIR}"
    echo "DONE"
fi

ln -sf "$HOME/bin/ripgrep/rg" "$HOME/bin/rg"

#################
# SDKMAN
#################

if [ ! -d "$HOME/bin/sdkman" ]; then
    echo -n "Installing SDKMAN ... "
    export SDKMAN_DIR="$HOME/bin/sdkman" && \
    curl -s "https://get.sdkman.io?rcupdate=false" | bash > /dev/null 2>&1
    echo "DONE"
fi

#################
# NEOVIM
#################

NVIM_VERSION=v0.10.0
NVIM_URL="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
NVIM_CHECKSUM_URL="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz.sha256sum"

if [ ! -d "$HOME/bin/neovim" ]; then
    echo -n "Installing NEOVIM... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/nvim.tar.gz -sL "$NVIM_URL"
    curl -o "${TEMP_DIR}"/nvim.sha256sum -sL "$NVIM_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < "${TEMP_DIR}"/nvim.sha256sum) ""${TEMP_DIR}""/nvim.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/neovim"
    tar -C "$HOME/bin/neovim" --strip-components=1 -xf "${TEMP_DIR}"/nvim.tar.gz
    rm "${TEMP_DIR}"/nvim.tar.gz "${TEMP_DIR}"/nvim.sha256sum
    echo "DONE"
fi

ln -sf "$HOME/bin/neovim/bin/nvim" "$HOME/bin/nvim"

#################
# SHELLCHECK
#################

SC_VERSION=v0.10.0
SC_SHA256=6c881ab0698e4e6ea235245f22832860544f17ba386442fe7e9d629f8cbedf87
SC_URL="https://github.com/koalaman/shellcheck/releases/download/$SC_VERSION/shellcheck-$SC_VERSION.linux.x86_64.tar.xz"

if [ ! -f "$HOME/bin/shellcheck" ]; then
    echo -n "Installing SC ... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/sc.tar.xz -sL "$SC_URL"
    echo "$SC_SHA256 ""${TEMP_DIR}""/sc.tar.xz" | sha256sum -c --quiet
    tar -C "$HOME/bin" --strip-components=1 -xf """${TEMP_DIR}""/sc.tar.xz" "shellcheck-$SC_VERSION/shellcheck"
    rm "${TEMP_DIR}"/sc.tar.xz
    echo "DONE"
fi

#################
# LAZYGIT
#################

LAZYGIT_VERSION=0.41.0
LAZYGIT_URL="https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
LAZYGIT_CHECKSUM_URL="https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/checksums.txt"
LAZYGIT_FILE=$(basename $LAZYGIT_URL)
LAZYGIT_CHECKSUM_FILE=$(basename $LAZYGIT_CHECKSUM_URL)

if [ ! -f "$HOME/bin/lazygit" ]; then
    echo -n "Installing LAZYGIT... "
    TEMP_DIR=$(mktemp -d)
    curl -o "${TEMP_DIR}"/"$LAZYGIT_FILE" -sL "$LAZYGIT_URL"
    curl -o "${TEMP_DIR}"/"$LAZYGIT_CHECKSUM_FILE" -sL "$LAZYGIT_CHECKSUM_URL"
    cd "${TEMP_DIR}" && (grep "$LAZYGIT_FILE" "$LAZYGIT_CHECKSUM_FILE" | sha256sum -c --quiet)
    mkdir -p "$HOME/bin/lazygit"
    tar -C "$HOME/bin" -xf "${TEMP_DIR}"/"$LAZYGIT_FILE" lazygit
    rm "${TEMP_DIR}"/"$LAZYGIT_FILE" "${TEMP_DIR}"/"$LAZYGIT_CHECKSUM_FILE"
    echo "DONE"
fi

echo "DONE"
