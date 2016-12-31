---
layout: default
permalink: /guides/logging-into-vagrant
title: Logging Into Vagrant Guide
---

#### Table Of Contents

- [OS X/Linux](#osx-linux)
- [Windows](#windows)

These instructions are specific to your operating system so scroll down to find the section for your OS.

<span class="anchor" id="osx-linux">&nbsp;</span>

####OS X/Linux

Assuming you created the "TwitterClone" folder on the Desktop, open the Mac application called "Terminal" in your Applications, and navigate to the project directory with:

```bash
# Terminal on host computer
cd ~/Desktop/TwitterClone
```

Type that into your terminal and press enter to run it.

Now that we are in our project directory, let's start our VM with the "vagrant up" command.

```bash
# Terminal on host computer
vagrant up
```

Type that into your terminal and press enter.   This command might take some time to finish, so be patient.  

Now we have our VM running, let's connect to it.  

```bash
# Terminal on host computer
vagrant ssh
```

Type that into your terminal and press enter.  You should see the last line of your terminal change format to look like this:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/ssh-login-to-vagrant.png)

You are now logged into your VM and are ready to get started.  All terminal commands from here on out will assume running them in your VM.

<span class="anchor" id="windows">&nbsp;</span>

####Windows

Assuming you created the "TwitterClone" folder on the Desktop, open "Windows Powershell" from the start menu.  I'll refer to "Windows Powershell" as the terminal for the rest of this guide.  Let's navigate to the project directory with:

```bash
# PowerShell on host computer
cd ~/Desktop/TwitterClone
```

Type that into your terminal and press enter to run it.

Now that we are in our project directory, let's start our VM with the "vagrant up" command.

```bash
# PowerShell on host computer
vagrant up
```

Type that into powershell and press enter.   This command might take some time to finish, so be patient. 

Now we have our VM running, let's connect to it. For Windows we are going to use Putty to log into our VM.

In order to log into our VM with Putty, we need login credentials.  Run the following command to get them:

```bash
# PowerShell on host computer
vagrant ssh-config
```

Type that into your terminal and press enter.  You should see something like the following.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/windows-ssh-config.png)

We are going to use this information to log into our VM with Putty.  Open Putty now and enter the hostname and port from our ssh-config command.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/logging-into-vagrant-with-putty.png)

Click the "Open" button and you should see a screen asking you for "login as:" which is the username.  Type "vagrant" and press enter.  When it asks for a password, also type "vagrant" and press enter.  When typing the password, you won't see any characters appear, but they are being entered.  Press enter and you should see the following prompt come up.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/putty-logged-into-vagrant.png)

You are now logged into your VM on your Windows machine.