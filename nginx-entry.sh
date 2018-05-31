#!/bin/bash
NEWUID=$(stat -c '%u' /var/www/html)
if [ $NEWUID -eq 0 ]; then
	echo "Not allowed for /var/www/html mount point owner to be 'root'"
else 
	usermod -u $NEWUID -o nginx
	echo change nginx user to uid = $NEWUID
fi
echo "$@"
exec "$@"



