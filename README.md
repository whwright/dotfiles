# dotfiles

Inspired by [mossberg's dotfiles](https://github.com/mossberg/dotfiles)

setup
-----

```
git clone git@github.com:wright8191/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
```


#### what does install.sh do?
1. init submodules
2. find all scripts named `install.sh` at depth=2 and run them
3. find all items named `*.symlink` and link them to `${HOME}`
    NOTE: if the item is `config.symlink`, then we expect 1 subdirectory,
    i.e. `config.symlink/awesome` which will be linked to `${HOME}/.config/awesome`
4. link all files in `bin/` to `/usr/local/bin`
