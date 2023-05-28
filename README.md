# Dotfiles

```sh
# install chezmoi
sh -c "$(curl -fsLS get.chezmoi.io)"

# install zsh plugins
$(chezmoi source-path)/setup-zsh-plugins.sh

# install various apps into ~/bin
$(chezmoi source-path)/setup-tools.sh

# clone dotfiles repo
chezmoi init aski

# apply configuration to local system
chezmoi apply
```
