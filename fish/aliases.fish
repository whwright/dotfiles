alias pyjson "python -m json.tool"
alias pyweb "python -m SimpleHTTPServer"
alias grip "grep -i"
alias psg "ps -ef | grep"
alias pubip "curl http://canihazip.com/s/; echo ''"
alias cll "clear; ll"


# python
alias veinit "virtualenv -p python3 venv; veon"
alias veon ". venv/bin/activate.fish"
alias veoff "deactivate"


# utils
alias gignorel "find . -type l | sed -e s'/^\.\///g' >> .gitignore"
