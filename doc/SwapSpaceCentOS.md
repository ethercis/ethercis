# Notes on OS configuration: Swap partition on CentOS

Christian Chevalley 3/8/2018

# Introduction

A swap partition is used to emulate virtual memory pagination between storage and RAM (see [Swap Space](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/5/html/deployment_guide/ch-swapspace) for more details). In the EtherCIS and VM context it is useful to avoid ethercis process killed by the OS due to out of memory condition.

Here is an illustration of two different OS configuration (dashboard from [Webmin](http://www.webmin.com/) 1.890):

![](https://i.imgur.com/ZAMsyoV.png) 

System on the right hand side indicates 'VIRTUAL MEMORY' (here a partition of 4GB).

In the following we assume CentOS 7 is the OS used to deploy EtherCIS.

# Configuring Swap Space

A simple (and efficient) step by step instructions can be found at DO [How To Add Swap on CentOS 7](https://www.digitalocean.com/community/tutorials/how-to-add-swap-on-centos-7)

**IMPORTANT**. Don't use `fallocate`, but use `sudo dd if=/dev/zero of=/swapfile count=4096 bs=1MiB` instead!!! 

