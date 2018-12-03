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
1. install private scripts
1. find all scripts named `install.sh` at depth=2 and run them
1. find all items named `*.symlink` and link them to `${HOME}`
    NOTE: if the item is `config.symlink`, then we expect 1 subdirectory,
    i.e. `config.symlink/awesome` which will be linked to `${HOME}/.config/awesome`
1. link all files from `bin/` to `/usr/local/bin` and remove any dead links
1. link all files from private scripts to `/usr/local/bin` and remove any dead links
1. link autorandr TODO: do I still need this?
1. install fzf TODO: it would be nice if this was generic


#### TODO:
1. clean up debinated things #32
1. rewrite install script
    - modularize install steps
    - list install scripts
        - it would be super nice if I could pull a docstring or something from them and show that
    - `link_file` sucks
    - see if there are still TODO comments in `install.sh`
