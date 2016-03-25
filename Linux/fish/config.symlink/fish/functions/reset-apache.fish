function reset-apache
    sudo gitlab-ctl stop
    sudo service apache2 restart
    sudo gitlab-ctl start
end
