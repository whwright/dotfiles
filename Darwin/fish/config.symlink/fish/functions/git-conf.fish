# TODO: put into install.sh
function git-conf
    if test (count $argv) -eq 0
        echo "missing argument"
        return 0
    else
        set -l __name "W. Harrison Wright"
        set -l __pers_email "wright8191@gmail.com"
        set -l __work_email "wrighthw@us.ibm.com"

        git config --global user.name $__name
        if [ $argv[1] = "p" -o $argv[1] = "pers" ]
            command git config --local user.email $__pers_email
        else if [ $argv[1] = "w" -o $argv[1] = "work" ]
            command git config --local user.email $__work_email
        else
            echo "bad argument: $argv[1]"
            return 0
        end
    end
end