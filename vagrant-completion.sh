complete -W "$(echo `vagrant --help | awk '/box/,/up/ {print $1}'`;)" vagrant
