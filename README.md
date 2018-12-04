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
1. more transparent way to run sudo

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
