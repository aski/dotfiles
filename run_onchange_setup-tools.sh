#!/usr/bin/env bash

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
    curl -o /tmp/awscliv2.zip -sL "$AWS_URL"
    rm -rf /tmp/aws
    unzip -qq /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install -u -i "$HOME/bin/aws-cli" -b "$HOME/bin" > /dev/null
    rm -rf /tmp/aws /tmp/awscliv2.zip
    echo "DONE"
fi

#################
# FD
#################

FD_VERSION=v8.3.2
FD_SHA256=64c43db1f6411df6dbe679d0881ac021b4fc8aec1b565a324cc6207aeada042f
FD_URL="https://github.com/sharkdp/fd/releases/download/$FD_VERSION/fd-$FD_VERSION-x86_64-unknown-linux-gnu.tar.gz"

if [ ! -d "$HOME/bin/fd.d" ]; then
    echo -n "Installing FD ... "
    curl -o /tmp/fd.tar.gz -sL "$FD_URL"
    echo "$FD_SHA256 /tmp/fd.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/fd.d"
    tar -C "$HOME/bin/fd.d" --strip-components=1 -xf /tmp/fd.tar.gz
    rm /tmp/fd.tar.gz
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
    curl -o /tmp/hadolint -sL "$HADOLINT_URL"
    curl -o /tmp/hadolint.sha256sum -sL "$HADOLINT_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < /tmp/hadolint.sha256sum) /tmp/hadolint" | sha256sum -c --quiet
    mv /tmp/hadolint "$HOME/bin"
    chmod +x "$HOME/bin/hadolint"
    rm /tmp/hadolint.sha256sum
    echo "DONE"
fi

#################
# HELM
#################

HELM_VERSION=v3.8.2
HELM_URL="https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz"
HELM_CHECKSUM_URL="https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz.sha256sum"

if [ ! -f "$HOME/bin/helm" ]; then
    echo -n "Installing HELM ... "
    curl -o /tmp/helm.tar.gz -sL "$HELM_URL"
    curl -o /tmp/helm.sha256sum -sL "$HELM_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < /tmp/helm.sha256sum) /tmp/helm.tar.gz" | sha256sum -c --quiet
    tar -C "$HOME/bin" --strip-components=1 -xzf "/tmp/helm.tar.gz" linux-amd64/helm
    rm "/tmp/helm.tar.gz" "/tmp/helm.sha256sum"
    echo "DONE"
fi

#################
# KUBECTL
#################

KUBECTL_VERSION=v1.23.6
KUBECTL_URL="https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl"
KUBECTL_CHECKSUM_URL="https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256"

if [ ! -f "$HOME/bin/kubectl" ]; then
    echo -n "Installing KUBECTL ... "
    curl -o /tmp/kubectl -sL "$KUBECTL_URL"
    curl -o /tmp/kubectl.sha256sum -sL "$KUBECTL_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < /tmp/kubectl.sha256sum) /tmp/kubectl" | sha256sum -c --quiet
    mv /tmp/kubectl "$HOME/bin"
    chmod +x "$HOME/bin/kubectl"
    rm /tmp/kubectl.sha256sum
    echo "DONE"
fi

#################
# RIPGREP
#################

RG_VERSION=13.0.0
RG_SHA256=ee4e0751ab108b6da4f47c52da187d5177dc371f0f512a7caaec5434e711c091
RG_URL="https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz"

if [ ! -d "$HOME/bin/ripgrep" ]; then
    echo -n "Installing RG ... "
    curl -o /tmp/rg.tar.gz -sL "$RG_URL"
    echo "$RG_SHA256 /tmp/rg.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/ripgrep"
    tar -C "$HOME/bin/ripgrep" --strip-components=1 -xf /tmp/rg.tar.gz
    rm /tmp/rg.tar.gz
    echo "DONE"
fi

ln -sf "$HOME/bin/ripgrep/rg" "$HOME/bin/rg"

#################
# SDKMAN
#################

if [ ! -d "$HOME/bin/sdkman" ]; then
    echo -n "Installing SDKMAN ... "
    export SDKMAN_DIR="$HOME/bin/sdkman" && \
    curl -s "https://get.sdkman.io" | bash > /dev/null 2>&1
    echo "DONE"
fi

#################
# NEOVIM
#################

NVIM_VERSION=v0.9.1
NVIM_URL="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
NVIM_CHECKSUM_URL="https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz.sha256sum"

if [ ! -d "$HOME/bin/neovim" ]; then
    echo -n "Installing NEOVIM... "
    curl -o /tmp/nvim.tar.gz -sL "$NVIM_URL"
    curl -o /tmp/nvim.sha256sum -sL "$NVIM_CHECKSUM_URL"
    echo "$(cut -d' ' -f1 < /tmp/nvim.sha256sum) /tmp/nvim.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/neovim"
    tar -C "$HOME/bin/neovim" --strip-components=1 -xf /tmp/nvim.tar.gz
    rm /tmp/nvim.tar.gz /tmp/nvim.sha256sum
    echo "DONE"
fi

ln -sf "$HOME/bin/neovim/bin/nvim" "$HOME/bin/nvim"

#################
# SHELLCHECK
#################

SC_VERSION=v0.8.0
SC_SHA256=ab6ee1b178f014d1b86d1e24da20d1139656c8b0ed34d2867fbb834dad02bf0a
SC_URL="https://github.com/koalaman/shellcheck/releases/download/$SC_VERSION/shellcheck-$SC_VERSION.linux.x86_64.tar.xz"

if [ ! -f "$HOME/bin/shellcheck" ]; then
    echo -n "Installing SC ... "
    curl -o /tmp/sc.tar.xz -sL "$SC_URL"
    echo "$SC_SHA256 /tmp/sc.tar.xz" | sha256sum -c --quiet
    tar -C "$HOME/bin" --strip-components=1 -xf "/tmp/sc.tar.xz" "shellcheck-$SC_VERSION/shellcheck"
    rm /tmp/sc.tar.xz
    echo "DONE"
fi
