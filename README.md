# dotfiles
Inspired by [whwright's dotfiles](https://github.com/whwright/dotfiles), with less?
Inspired by [mossberg's dotfiles](https://github.com/mossberg/dotfiles), with _several_ twists.

setup
-----

```
git clone git@github.com:rdooley/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh all
```

#### what does install.sh do?
```
↪ ./install.sh -h
Usage: install.sh [OPTION]... [THING TO RUN]...

Things to run:
    all                  run everything
    bin                  link binaries
    dotfiles             link dotfiles/run related install scripts
    scripts              run install scripts

Options:
    -h, --help           print this message and exit
    --dry-run            outputs the operations that would run, but does not run them
```

- `bin`
    - link all files from `bin/` to `/usr/local/bin` and remove any dead links
    - install private scripts
    - link all files from private scripts to `/usr/local/bin` and remove any dead links
- `dotfiles`
    - find all items named `*.symlink` and link them to `${HOME}`
        NOTE: if the item is `config.symlink`, then we expect 1 subdirectory,
        i.e. `config.symlink/awesome` which will be linked to `${HOME}/.config/awesome`
- `scripts`
    - find all scripts named `install.sh` at depth=2 and run them
