#!/usr/bin/env bash

set -e

#################
# FZF
#################

if test ! -d "$HOME/bin/fzf.d";
then
    git clone -q --depth 1 --branch master \
        --single-branch https://github.com/junegunn/fzf "$HOME/bin/fzf.d"
    "$HOME/bin/fzf.d/install" --all --xdg --no-update-rc
fi

#################
# AWS CLI
#################

if test ! -f "$HOME/bin/aws";
then
    echo -en "Installing AWS CLI v2 ... "
    curl -sL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
    rm -rf /tmp/aws
    unzip -qq /tmp/awscliv2.zip -d /tmp
    /tmp/aws/install -u -i "$HOME/bin/aws-cli" -b "$HOME/bin" > /dev/null
    rm -rf /tmp/aws /tmp/awscliv2.zip
    # TODO checksum
    echo "DONE"
fi

#################
# FD
#################

FD_VERSION=v8.3.2
FD_SHA256=64c43db1f6411df6dbe679d0881ac021b4fc8aec1b565a324cc6207aeada042f

if test ! -d "$HOME/bin/fd.d";
then
    echo -en "Installing FD ... "
    curl -sL "https://github.com/sharkdp/fd/releases/download/$FD_VERSION/fd-$FD_VERSION-x86_64-unknown-linux-gnu.tar.gz" -o /tmp/fd.tar.gz
    echo "$FD_SHA256 /tmp/fd.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/fd.d"
    tar -C "$HOME/bin/fd.d" --strip-components=1 -xf /tmp/fd.tar.gz
    rm /tmp/fd.tar.gz
    echo "DONE"
fi

rm -f "$HOME/bin/fd"
ln -s "$HOME/bin/fd.d/fd" "$HOME/bin/fd"

#################
# HADOLINT
#################

HADOLINT_VERSION=v2.10.0
HADOLINT_SHA256=8ee6ff537341681f9e91bae2d5da451b15c575691e33980893732d866d3cefc4

if test ! -f "$HOME/bin/hadolint";
then
    echo -en "Installing HADOLINT ... "
    curl -sL "https://github.com/hadolint/hadolint/releases/download/$HADOLINT_VERSION/hadolint-Linux-x86_64" -o /tmp/hadolint
    echo "$HADOLINT_SHA256 /tmp/hadolint" | sha256sum -c --quiet
    mv /tmp/hadolint "$HOME/bin"
    chmod +x "$HOME/bin/hadolint"
    echo "DONE"
fi

#################
# HELM
#################

HELM_VERSION=v3.8.2

if test ! -d "$HOME/bin/helm.d";
then
    echo -en "Installing HELM ... "
    curl --output-dir /tmp -sLO "https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz"
    curl --output-dir /tmp -sLO "https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz.sha256sum"
    (cd /tmp && sha256sum "helm-$HELM_VERSION-linux-amd64.tar.gz.sha256sum" -c --quiet)
    mkdir -p "$HOME/bin/helm.d"
    tar -C "$HOME/bin/helm.d" --strip-components=1 -xzf "/tmp/helm-$HELM_VERSION-linux-amd64.tar.gz"
    rm "/tmp/helm-$HELM_VERSION-linux-amd64.tar.gz" "/tmp/helm-$HELM_VERSION-linux-amd64.tar.gz.sha256sum"
    echo "DONE"
fi

rm -f "$HOME/bin/helm"
ln -s "$HOME/bin/helm.d/helm" "$HOME/bin/helm"

#################
# KUBECTL
#################

KUBECTL_VERSION=v1.23.6

if test ! -f "$HOME/bin/kubectl";
then
    echo -en "Installing KUBECTL ... "
    curl -sL "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" -o /tmp/kubectl
    curl -sL "https://dl.k8s.io/$KUBECTL_VERSION/bin/linux/amd64/kubectl.sha256" -o /tmp/kubectl.sha256
    echo "$(cat /tmp/kubectl.sha256)  /tmp/kubectl" | sha256sum -c --quiet
    mv /tmp/kubectl "$HOME/bin"
    chmod +x "$HOME/bin/kubectl"
    rm /tmp/kubectl.sha256
    echo "DONE"
fi

#################
# RIPGREP
#################

RG_VERSION=13.0.0
RG_SHA256=ee4e0751ab108b6da4f47c52da187d5177dc371f0f512a7caaec5434e711c091

if test ! -d "$HOME/bin/ripgrep";
then
    echo -en "Installing RG ... "
    curl -sL "https://github.com/BurntSushi/ripgrep/releases/download/$RG_VERSION/ripgrep-$RG_VERSION-x86_64-unknown-linux-musl.tar.gz" -o /tmp/rg.tar.gz
    echo "$RG_SHA256 /tmp/rg.tar.gz" | sha256sum -c --quiet
    mkdir -p "$HOME/bin/ripgrep"
    tar -C "$HOME/bin/ripgrep" --strip-components=1 -xf /tmp/rg.tar.gz
    rm /tmp/rg.tar.gz
    echo "DONE"
fi

rm  -f "$HOME/bin/rg"
ln -s "$HOME/bin/ripgrep/rg" "$HOME/bin/rg"

#################
# SDKMAN
#################

if test ! -d "$HOME/bin/sdkman";
then
    echo -en "Installing SDKMAN ... "
    export SDKMAN_DIR="$HOME/bin/sdkman" && curl -s "https://get.sdkman.io" | bash > /dev/null 2>&1
    echo "DONE"
fi

#################
# NEOVIM
#################

NVIM_VERSION=v0.9.0

if test ! -d "$HOME/bin/neovim";
then
    echo -en "Installing NEOVIM... "
    curl --output-dir /tmp -sLO "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz"
    curl --output-dir /tmp -sLO "https://github.com/neovim/neovim/releases/download/$NVIM_VERSION/nvim-linux64.tar.gz.sha256sum"
    (cd /tmp && sha256sum "nvim-linux64.tar.gz.sha256sum" -c --quiet)
    mkdir -p "$HOME/bin/neovim"
    tar -C "$HOME/bin/neovim" --strip-components=1 -xf /tmp/nvim-linux64.tar.gz
    rm /tmp/nvim-linux64.tar.gz /tmp/nvim-linux64.tar.gz.sha256sum
fi

rm -f "$HOME/bin/vim" "$HOME/bin/nvim"
ln -s "$HOME/bin/neovim/bin/nvim" "$HOME/bin/nvim"
ln -s "$HOME/bin/neovim/bin/nvim" "$HOME/bin/vim"

#################
# SHELLCHECK
#################

SHELLCHECK_VERSION=v0.8.0
SHELLCHECK_SHA256=ab6ee1b178f014d1b86d1e24da20d1139656c8b0ed34d2867fbb834dad02bf0a

if test ! -f "$HOME/bin/shellcheck";
then
    echo -en "Installing SHELLCHECK ... "
    curl --output-dir /tmp -sLO "https://github.com/koalaman/shellcheck/releases/download/$SHELLCHECK_VERSION/shellcheck-$SHELLCHECK_VERSION.linux.x86_64.tar.xz"
    echo "$SHELLCHECK_SHA256 /tmp/shellcheck-$SHELLCHECK_VERSION.linux.x86_64.tar.xz" | sha256sum -c --quiet
    tar -C "$HOME/bin" --strip-components=1 \
        -xf "/tmp/shellcheck-$SHELLCHECK_VERSION.linux.x86_64.tar.xz" \
        "shellcheck-$SHELLCHECK_VERSION/shellcheck"
    rm /tmp/shellcheck-$SHELLCHECK_VERSION.linux.x86_64.tar.xz
fi
