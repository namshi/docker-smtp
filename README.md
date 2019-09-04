# Docker-SMTP
[![](https://images.microbadger.com/badges/image/namshi/smtp.svg)](https://microbadger.com/images/namshi/smtp)

This is a SMTP docker container for sending emails. You can also relay emails to gmail and amazon SES.

## Environment variables

The container accepts `RELAY_NETWORKS` environment variable which *MUST* start with `:` e.g `:192.168.0.0/24` or `:192.168.0.0/24:10.0.0.0/16`.

The container accepts `KEY_PATH` and `CERTIFICATE_PATH` environment variable that if provided will enable TLS support. The paths must be to the key and certificate file on a exposed volume. The keys will be copied into the container location.

The container accepts `MAILNAME` environment variable which will set the outgoing mail hostname.

The container also accepts the `PORT` environment variable, to set the port the mail daemon will listen on inside the container. The default port is `25`.

To disable IPV6 you can set the `DISABLE_IPV6` environment variable to any value.

The container accepts `OTHER_HOSTNAMES` environment variable which will set the list of domains for which this machine should consider itself the final destination.

## Below are scenarios for using this container

### As SMTP Server
You don't need to specify any environment variable to get this up.

### As a Secondary SMTP Server
Specify 'RELAY_DOMAINS' to setup what domains should be accepted to forward to lower distance MX server.

Format is `<domain1> : <domain2> : <domain3> etc`

### As Gmail Relay
You need to set the `GMAIL_USER` and `GMAIL_PASSWORD` to be able to use it.

### As Amazon SES Relay
You need to set the `SES_USER` and `SES_PASSWORD` to be able to use it.<br/>
You can override the SES region by setting `SES_REGION` as well.
If you use Google Compute Engine you also should set `SES_PORT` to 2587.

### As generic SMTP Relay
You can also use any generic SMTP server with authentication as smarthost.</br>
You need to set `SMARTHOST_ADDRESS`, `SMARTHOST_PORT` (connection parameters), `SMARTHOST_USER`, `SMARTHOST_PASSWORD` (authentication parameters), and `SMARTHOST_ALIASES`: this is a list of aliases to puth auth data for authentication, semicolon separated.</br>

```
Example:

 * SMARTHOST_ADDRESS=mail.mysmtp.com
 * SMARTHOST_PORT=587
 * SMARTHOST_USER=myuser
 * SMARTHOST_PASSWORD=secret
 * SMARTHOST_ALIASES=*.mysmtp.com
```
