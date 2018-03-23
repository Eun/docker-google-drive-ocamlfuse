#!/bin/bash

DRIVE_PATH=${DRIVE_PATH:-/mnt/gdrive}

PUID=${PUID:-0}
PGID=${PGID:-0}

# Create a group for our gid if required
if [ -z "$(getent group gdfuser)" ]; then
	echo "creating gdfuser group for gid ${PGID}"
	groupadd --gid ${PGID} --non-unique gdfuser >/dev/null 2>&1
fi

# Create a user for our uid if required
if [ -z "$(getent passwd gdfuser)" ]; then
	echo "creating gdfuser group for uid ${PUID}"
	useradd --gid ${PGID} --non-unique --comment "Google Drive Fuser" \
	 --home-dir "/config" --create-home \
	 --uid ${PUID} gdfuser >/dev/null 2>&1

	echo "taking ownership of /config for gdfuser"
	chown ${PUID}:${PGID} /config
fi

# check if our config exists already
if [ -e "/config/.gdfuse/default/config" ]; then
	echo "existing google-drive-ocamlfuse config found"
else
	# create a fake xdg-open
	cat > /bin/xdg-open <<- EOF
#!/bin/bash
echo \$@ > /tmp/auth.txt
EOF
    chmod +x /bin/xdg-open
		
	# create a loop that reads /tmp/auth.txt
    cat > /bin/read-auth.sh <<- EOF
#!/bin/bash
while [ ! -f /tmp/auth.txt ]
do
  sleep 1
done
echo "VISIT THE FOLLOWING URL TO AUTHORIZE:"
cat /tmp/auth.txt
EOF
	chmod +x /bin/read-auth.sh
	
	/bin/read-auth.sh &
	echo "initilising google-drive-ocamlfuse..."
	su gdfuser -l -c  "google-drive-ocamlfuse"
fi

# prepend additional mount options with a comma
if [ -z "${MOUNT_OPTS}" ]; then
	MOUNT_OPTS=",${MOUNT_OPTS}"
fi

# mount as the gdfuser user
echo "mounting at ${DRIVE_PATH}"
exec su gdfuser -l -c "google-drive-ocamlfuse \"${DRIVE_PATH}\" -f -o uid=${PUID},gid=${PGID}${MOUNT_OPTS}"

