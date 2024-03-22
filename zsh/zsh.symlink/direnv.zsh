#!/usr/bin/env zsh

if ! type direnv > /dev/null; then
  return
fi

eval "$(direnv hook zsh)"

# Restore PS1
# https://github.com/direnv/direnv/wiki/Python#zsh
setopt PROMPT_SUBST

show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
    echo "($(basename $VIRTUAL_ENV))"
  fi
}
PS1='$(show_virtual_env)'$PS1
