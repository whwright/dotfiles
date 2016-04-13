alias pyjson "python -m json.tool"
alias pyweb "python -m SimpleHTTPServer"
alias grip "grep -i"
alias psg "ps -ef | grep"
alias pubip "curl http://canihazip.com/s/; echo ''"


# git
alias g "git status -sb"
alias gg "git status"
alias ga "git add"
alias gau "git add -u"
alias gc "git commit"
alias gco "git checkout"
alias gb "git branch"
alias gd "git diff"
alias gl "git log"
alias gll "git log --graph --oneline --all --decorate -n 25"
alias glll "git log --graph --oneline --all --decorate"


# python
alias veinit "virtualenv -p python3 venv; veon"
alias veon ". venv/bin/activate.fish"
alias veoff "deactivate"


# utils
alias gignorel "find . -type l | sed -e s'/^\.\///g' >> .gitignore"
