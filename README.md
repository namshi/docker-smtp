# Docker-SMTP

This is a SMTP docker container for sending emails. You can also relay emails to gmail and amazon SES.

## Environment variables
The container accepts `RELAY_NETWORKS` environment variable which *MUST* start with `:` e.g `:192.168.0.0/24` or `:192.168.0.0/24:10.0.0.0/16`.

## Below are scenarios for using this container

### As SMTP Rerver
You don't need to specify any environment variable to get this up.

### As Gmail Relay
You need to set the `GMAIL_USER` and `GMAIL_PASSWORD` to be able to use it.

### As Amazon SES Relay
You need to set the `SES_USER` and `SES_PASSWORD` to be able to use it.<br/>
You can override the SES region by setting `SES_REGION` as well.
