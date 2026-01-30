# dotfiles

dotfiles, scripts, and stuff to setup my development environment

setup
-----

```
git clone git@github.com:whwright/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```

# TODO:
- [ ] better loading of gnome keyboads if I keep going that route

```
# Export current keybindings to a file
dconf dump /org/gnome/settings-daemon/plugins/media-keys/ > keybindings.dconf

# Import later or on another machine
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < keybindings.dconf
```
