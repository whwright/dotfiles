function block-ip
    if not test (count $argv) -eq 1
        echo "usage: block-ip [ip_addr]"
        return 1
    end

    if read_confirm "Are you sure you want to block IP $argv[1]? (y/n) "
        sudo iptables -A INPUT -s $argv[1] -j DROP
        echo "$argv[1] blocked"
        return 0
    else
        echo "aborted"
        return 1
    end
end
