function read_confirm
    set -g prompt "Do you want to continue? (y/n) "
    if test (count $argv) -eq 1
        set prompt $argv[1]
    end

    function read_prompt
        echo $prompt
    end

    while true
        read -l -p read_prompt confirm

        switch $confirm
            case Y y
                return 0
            case N n
                return 1
        end
    end
end