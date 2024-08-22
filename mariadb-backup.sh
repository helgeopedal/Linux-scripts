#!/bin/bash

# Helge Opedal
# Disclaimer
# Please I don't take any responsibility for any errors this script might do
# Always remember to test before running any on a production server

# TODO
# Make sure /backup/ folder exists. Hint: mkdir /backup/
# then run: git init
# in the /backup/ folder

# Find all mariadb databases
# NOTE: check if the commands actually gives a reasonable list. It might vary on different Linux systems
LISTA=`find /var/lib/mysql/ -maxdepth 1 -type d | awk -F '/' '{print $5}' | sort | uniq | sed '/^$/d'`

for i in $LISTA; do echo "cd /backup/; mysqldump --lock-tables=false $i  > /backup/$i.$(date +%Y-%m-%d:%T).sql"; done > /backup/runme.sh
echo "cd /backup/; gzip *.sql" >> /backup/runme.sh

# Make the script runable
chmod 755 /backup/runme.sh

# Run backup
/backup/runme.sh

# Track your commands in a local git repo
cd /backup/
git commit -m "runme.sh: mariadb-backup commands" runme.sh

exit;
