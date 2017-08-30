#!/bin/bash
set -e

# Initialize localmacros as an empty file
echo -n "" > /etc/exim4/exim4.conf.localmacros

if [ "$MAILNAME" ]; then
	echo "MAIN_HARDCODE_PRIMARY_HOSTNAME = $MAILNAME" > /etc/exim4/exim4.conf.localmacros
	echo $MAILNAME > /etc/mailname
fi

if [ "$KEY_PATH" -a "$CERTIFICATE_PATH" ]; then
	if [ "$MAILNAME" ]; then
	  echo "MAIN_TLS_ENABLE = yes" >>  /etc/exim4/exim4.conf.localmacros
	else
	  echo "MAIN_TLS_ENABLE = yes" >>  /etc/exim4/exim4.conf.localmacros
	fi
	cp $KEY_PATH /etc/exim4/exim.key
	cp $CERTIFICATE_PATH /etc/exim4/exim.crt
	chgrp Debian-exim /etc/exim4/exim.key
	chgrp Debian-exim /etc/exim4/exim.crt
	chmod 640 /etc/exim4/exim.key
	chmod 640 /etc/exim4/exim.crt
fi

opts=(
	dc_local_interfaces "[0.0.0.0]:${PORT:-25} ; [::0]:${PORT:-25}"
	dc_other_hostnames ''
	dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }' | xargs | sed 's/ /:/g')${RELAY_NETWORKS}"
)

if [ "$DISABLE_IPV6" ]; then 
        echo 'disable_ipv6=true' >> /etc/exim4/exim4.conf.localmacros
fi

if [ "$GMAIL_USER" -a "$GMAIL_PASSWORD" ]; then
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost 'smtp.gmail.com::587'
	)
	echo "*.google.com:$GMAIL_USER:$GMAIL_PASSWORD" > /etc/exim4/passwd.client
elif [ "$SES_USER" -a "$SES_PASSWORD" ]; then
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost "email-smtp.${SES_REGION:=us-east-1}.amazonaws.com::${SES_PORT:=587}"
	)
	echo "*.amazonaws.com:$SES_USER:$SES_PASSWORD" > /etc/exim4/passwd.client
# Allow to specify an arbitrary smarthost.
# Parameters: SMARTHOST_USER, SMARTHOST_PASSWORD: authentication parameters
# SMARTHOST_ALIASES: list of aliases to puth auth data for (semicolon separated)
# SMARTHOST_ADDRESS, SMARTHOST_PORT: connection parameters.
elif [ "$SMARTHOST_ADDRESS" ] ; then
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost "${SMARTHOST_ADDRESS}::${SMARTHOST_PORT-25}"
	)
	rm -f /etc/exim4/passwd.client
	if [ "$SMARTHOST_ALIASES" -a "$SMARTHOST_USER" -a "$SMARTHOST_PASSWORD" ] ; then
		echo "$SMARTHOST_ALIASES;" | while read -d ";" alias; do
			echo "${alias}:$SMARTHOST_USER:$SMARTHOST_PASSWORD" >> /etc/exim4/passwd.client
		done
	fi
elif [ "$RELAY_DOMAINS" ]; then
	opts+=(
		dc_relay_domains "${RELAY_DOMAINS}"
		dc_eximconfig_configtype 'internet'
	)
else
	opts+=(
		dc_eximconfig_configtype 'internet'
	)
fi

# allow to add additional macros by bind-mounting a file
if [ -f /etc/exim4/_docker_additional_macros ]; then
	cat /etc/exim4/_docker_additional_macros >> /etc/exim4/exim4.conf.localmacros
fi

/bin/set-exim4-update-conf "${opts[@]}"

exec "$@"
