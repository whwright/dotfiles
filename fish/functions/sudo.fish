function sudo
    if test "$argv" = !!
        set LAST_COMMAND $history[1]
        echo "sudo $LAST_COMMAND"
        eval command sudo $LAST_COMMAND
    else
        command sudo $argv
    end
end
