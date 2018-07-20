# Naming and Monitoring EtherCIS with WebMin

This is an how-to to implement basic monitoring and server restart with email notification using WebMin

## 1. Naming a Running Instance

A server instance can be named (e.g. using a ``ps -ef`` command) with an explicit name instead of a generic `java` with parameters.

The launch script is modified as follows:

    (
    echo "launching vEhr...."
        exec -a ${INSTANCE_NAME} ${JVM} -Xmx256M ...

Variable `INSTANCE_NAME` can be defined in the script or in `env.rc` or as a shell variable.

For example, if `INSTANCE_NAME` is 'ethercis-server-1', the process will be identified as:

	[ethercis@EtherCIS1 ~]$ ps -ef | grep ethercis-test
	ethercis  8327     1 11 04:08 ?        00:00:09 ethercis-test-1 -Xmx256M ....

We can now use this name to reference the running process in a monitoring framework.

## 2. Monitoring EtherCIS and Automating Restart

To achieve this goal we are using [Webmin](http://www.webmin.com/).

Webmin comes with a useful module 'System and Server Status' that can be used to perform monitoring with automated actions and notifications.

![](https://i.imgur.com/Ltd9Aez.png)

The monitoring is done as a scheduled monitoring which is configured as follows:

![](https://i.imgur.com/oPum4UT.png)

In `Email status report to` indicate the recipient(s) for the alarm notification
In `SMTP server` indicate a valid SMTP server used to relay the mail to its recipient(s)

In the above example, the monitoring is done every minutes. 

The specific configuration for ethercis is as follows (assuming the process is launched with the name defined above):

![](https://i.imgur.com/CiOAuIR.png)

If the process is down, it is automatically restarted with the command `~ethercis/ecis-server start` and an email is sent to the specified recipient.

# Note on configuring SMTP with Webmin

The configuration can be done in the Webmin Configuration->Sending Email

For example, using gmail as an SMTP server:

![](https://i.imgur.com/VEbzThr.png)

# Alternative Process Monitoring

An other possibility involves using Linux [`monit`](https://mmonit.com/monit/), the same principles apply. 

   
