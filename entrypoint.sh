#!/bin/bash
set -e

opts=(
	dc_local_interfaces '0.0.0.0 ; ::0'
	dc_other_hostnames ''
	dc_relay_nets "$(ip addr show dev eth0 | awk '$1 == "inet" { print $2 }')"
)

if [ "$GMAIL_USER" -a "$GMAIL_PASSWORD" ]; then
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost 'smtp.gmail.com::587'
	)
	echo "*.google.com:$GMAIL_USER:$GMAIL_PASSWORD" > /etc/exim4/passwd.client
elif [ "$SES_USER" -a "$SES_PASSWORD" ]; then
	opts+=(
		dc_eximconfig_configtype 'smarthost'
		dc_smarthost "email-smtp.${SES_REGION:=us-east-1}.amazonaws.com::587"
	)
	echo "*.amazonaws.com:$SES_USER:$SES_PASSWORD" > /etc/exim4/passwd.client
else
	opts+=(
		dc_eximconfig_configtype 'internet'
	)
fi

/bin/set-exim4-update-conf "${opts[@]}"

exec "$@"
