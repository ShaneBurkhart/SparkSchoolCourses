---
layout: default
permalink: /courses/twitter-clone/1/3
title: 1.3 Setup Your Project And Connect To Your VM
course: Twitter Clone
section: 'Day 1: Getting Your Development Environment Setup'
next-lesson-link: /courses/twitter-clone/1/4
---

####Table Of Contents

- [1.1 Introduction](/courses/twitter-clone/1/1)
- [1.2 Installing Tools](/courses/twitter-clone/1/2)
- **1.3 Setup Your Project And Connect To Your VM**
- [1.4 Your First Javascript Program](/courses/twitter-clone/1/4)
- [1.5 Writing Your First Web Server](/courses/twitter-clone/1/5)

To set up our project, we need to create a place to store our project files and connect to our VM so we can develop our web app in it.

The first thing we need to do is create a folder for our project files.  I like to keep all of my projects on the Desktop, so we'll be creating our project directory there.  Go to your Desktop and create a folder called "TwitterClone".  This will be our project folder.

In software development, we call folders directories and it's a good idea to name directories with no spaces so our directory names are easier to type.  In this tutorial, I use folder and directory interchangeably.

Now we need to create a Vagrant file to manage the VM settings for our project.  Vagrant expects this file to be in the root of your project and expects it to be called "Vagrantfile".  Let's create that file now.

When I refer to the root of the directory, I mean in the actual directory itself and not in a child directory.

Open Sublime Text 3 and go to File > New File.  Now go to File > Save As and save this file in our "TwitterClone" folder we just made and give it the name "Vagrantfile".  Click save and you now have an empty Vagrantfile.

Our file doesn't do anything yet since it's blank, but we are going to fix that now.  Type the following code into the file and save:

```ruby
# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "node-mysql"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
end
```

We aren't going to cover Vagrant in detail, but I'll explain what we are doing here. The first line is simply something we do so Vagrant knows we are setting configuration for our VM.  The indented lines inside of that are the important parts.

The first indented line tells Vagrant that we want to use the box that I made for the course called "node-mysql".  This is a Ubuntu box that I created that is ready to go so you don't have to install things like Node, MySQL, etc.

The next line forwards port 8080 from the VM to the host machine.  Our web server is going to run on port 8080 for development so we need to be able to access that. If you don't know what ports are, don't worry, I'll explain them a little later.  For now, just know that our web server is going to run on our VM and this line let's us access it from our browser.

###Connect To The VM

Now that we have defined what our VM will look like for our project, we need to start it and connect to it.  Our goal here is to start the VM on your computer so we can log into that run terminal commands in our VM.

In our Vagrantfile, we configured our VM to use the "node-mysql" box, but we haven't told Vagrant where to find it yet.  Open your terminal (PowerShell on Windows. Terminal on OSX/Linux) and copy the following into your terminal.  Press enter to run it.

```bash
# Terminal (or PowerShell) on host computer
vagrant box add --name node-mysql "https://s3.amazonaws.com/spark-school/node-mysql.box"
```

If this command fails to run saying there was an error, you might have to install an older version of vagrant.  Some people have contacted me telling me that they have ran into this issue and the fix is to download an older version.  [https://releases.hashicorp.com/vagrant/](https://releases.hashicorp.com/vagrant/) Visit that link to see a list of vagrant versions you can download. I would try a version or two down from the top.  Click that and you will see a page with links to installers.  For windows download the ".msi" version and for OS X, download the ".dmg" version.

We have now added our "node-mysql" box to vagrant on our local machine.

To connect to our VM, Vagrant uses SSH. SSH stands for secure shell and is a protocol used to run commands on other computers that are not the host computer. The secure part means we need we need correct user authentication to run commands on the remote machine.  We are going to have a VM running on our computer which will act as a remote machine.  You don't need to know much about SSH except that we are going to use it to log into our VM.

Let's get started.  I'm going to explain the terminal later, but for right now, follow the instructions to start and log into your VM.  All terminal commands after this section will be run in our VM, so for the rest of the course, I'm going to assume you are logged in.  If you ever need help logging back into your VM, you can use <a href="/guides/logging-into-vagrant" target="_blank">this guide to logging into Vagrant</a>.  I'll also add a link to the guide at the start of each day so it's easy for you to access.

These instructions are specific to your operating system so scroll down to find the section for your OS.

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

Type that into your terminal and press enter.   This command takes some time to finish, so be patient.   If your Vagrantfile is correct, vagrant should start your VM and tell you everything worked successfully.

Now we have our VM running, let's connect to it.  On Unix based operating systems, this is easy because we can run "vagrant ssh" and Vagrant will take care the our user authentication for us.

```bash
# Terminal on host computer
vagrant ssh
```

Type that into your terminal and press enter.  You should see the last line of your terminal change format to look like this:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/ssh-login-to-vagrant.png)

You are now logged into your VM and are ready to get started.  All terminal commands from here on out will assume you are logged into your VM.  If you ever need help getting logged back in, look back here as a reference.

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

Type that into the terminal and press enter.   This command takes some time to finish, so be patient.   If your Vagrantfile is correct, vagrant should start your VM and tell you everything worked successfully.

Now we have our VM running, let's connect to it.  For Windows we are going to use Putty to log into our VM.

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

### Final Code

```ruby
# Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.box = "node-mysql"
  config.vm.network "forwarded_port", guest: 8080, host: 8080
end
```
