# Docker-SMTP

This is a SMTP docker container for sending emails. You can also relay emails to gmail and amazon SES.
<br/>
<br/>

Below are scenarios for using this container

### As SMTP Rerver
You don't need to specify any environment variable to get this up.

### As Gmail Relay
You need to set the `GMAIL_USER` and `GMAIL_PASSWORD` to be able to use it.

### As Amazon SES Relay
You need to set the `SES_USER` and `SES_PASSWORD` to be able to use it.<br/>
You can override the SES region by setting `SES_REGION` as well.
