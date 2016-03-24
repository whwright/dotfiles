# reads password from user input
# arg1 - string to prompt user with
# arg2 - variable to store password in
function read_passwd
    echo -n $argv[1]
    stty -echo
    head -n 1 | read -g $argv[2]
    stty echo
    echo
end