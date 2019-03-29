# dotfiles

Inspired by [mossberg's dotfiles](https://github.com/mossberg/dotfiles), with _several_ twists.

setup
-----

```
git clone git@github.com:wright8191/dotfiles.git ~/.dotfiles
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

#### TODO:
1. TODO comments in `install.sh`
1. audit install scripts for linux only things
1. other linux specific things https://github.com/whwright/dotfiles/commit/faca65a233b3c52cdbe851f9240114a992fffdba#diff-3fbb47e318cd8802bd325e7da9aaabe8R102

#### How to add a new debinate package?
1. Fork the repo
1. Add the fork as a submodule
```
$ cd python
$ git sudmodule add ${fork_url}
```
1. Create a new branch `debinate`
1. Initialize debinate things
```
$ debinate init
$ touch .debinate/root/.gitkeep-${project_name}
$ sed -i 's/Debinate/${project_name}/' .debinate/after_install.sh
$ sed -i 's/Debinate/${project_name}/' .debinate/before_remove.sh
$ echo ".debinate/build/" >> .gitignore
$ echo ".debinate/cache/" >> .gitignore
$ echo ".debinate/target/" >> .gitignore
```
1. Update the `depends` file, if necessary
1. (optional) Create `debinate.json`, which can contain the following properties
    - `python_interpreter`: The python interpreter to use. This will default to system `python`.
    - `linked_binary`: The name of a binary file that will end up in the virtual environment's `bin` directory to link to `/usr/local/bin`.
      If this is omited, no binary is linked.
