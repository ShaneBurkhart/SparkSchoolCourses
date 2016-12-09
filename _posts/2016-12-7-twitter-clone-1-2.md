---
layout: default
permalink: /courses/twitter-clone/1/2
title: 1.2 Installing Tools
course: Twitter Clone
section: 'Day 1: Getting Your Development Environment Setup'
next-lesson-link: /courses/twitter-clone/1/3
---

####Table Of Contents

- [1.1 Introduction](/courses/twitter-clone/1/1)
- **1.2 Installing Tools**
- [1.3 Setup Your Project And Connect To Your VM](/courses/twitter-clone/1/3)
- [1.4 Your First Javascript Program](/courses/twitter-clone/1/4)
- [1.5 Writing Your First Web Server](/courses/twitter-clone/1/5)

Before we can start coding, we need to install some tools that we are going to use to build our Twitter clone.  Some tools are specific to certain operating systems.  Read through the whole section to make sure you have everything you need.

###Installing VirtualBox

Because everyone is on different operating systems (OS), it would be essentially two different guides for developing on Windows vs OS X.  Although they are getting better, Windows doesn't have nearly the dev tools or support that a Unix based OS (OS X or Linux) has.  Because of this, the industry standard is to use a Unix based operating systems to develop on.  We'll be doing the same since it makes the most sense.

We are going to develop in a virtual machine (VM) so everything is the same for everyone taking the course.  A virtual machine creates a fake computer, running on your current computer, that we can log into and use just like any other computer.  You don't need to know much about VMs, but just know that it creates a consistent environment for everyone so it's easier to learn.

Our VM is going to be running Ubuntu which is a version of Linux.  Even if you are running OS X or linux already, I recommend using my VM since I have already installed a lot of things for you and a lot of what you learn will transfer over anyways.

For our VM software, we are going to be using VirtualBox.  Go to [https://www.virtualbox.org/wiki/Downloads](https://www.virtualbox.org/wiki/Downloads) and download the correct version for your operating system. Open the file that was downloaded and follow the instructions to install VirtualBox.  Just use the default settings.

###Installing Vagrant

VirtualBox allows us to create VMs but that's about it.  With VMs there is generally a lot of configuration that has to be done to get started.  Because of this, we use a program called Vagrant to manage the VM for our project.

Vagrant allows you to define a file, for the project, that describes how the project's VM should be built and configured.  This cuts out all of the hard work for us and let's Vagrant handle all of the details of starting the VM.

To install Vagrant, go to [https://www.vagrantup.com/downloads.html](https://www.vagrantup.com/downloads.html) and download the appropriate version for your OS.

###Installing Sublime Text 3

We need a good text editor to write code.  My personal favorite text editor for beginners is Sublime Text 3.  Sublime Text 3 does a nice job of being easy to use while also including a lot of important tools if you want them.

To install Sublime Text 3, go to [https://www.sublimetext.com/3](https://www.sublimetext.com/3) and download the version for your operating system.  Open the file you downloaded and use the default settings.

###Installing A MySQL Database GUI

MySQL is the database server we are going to be running and we need a way to read and modify our database.  You can do this many ways, but the easiest is with a GUI (graphic user interface) program.

Unfortunately, there isn't a great GUI that runs on both OS X and Windows so we are going to download different version for each OS.  When we use our MySQL GUI, I'll make sure to explain how to use both versions.

####Windows - HeidiSQL

Go to [http://www.heidisql.com/download.php?download=installer](http://www.heidisql.com/download.php?download=installer) which should start downloading the installer.  Open the installer you just downloaded and use the default settings.

HeidiSQL also requires we download a program called plink.exe.  Go to this page [http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) and click the link that says "plink.exe".  Put this somewhere easy to access because we will need this later.

####OS X - Sequel Pro

Go to [https://www.sequelpro.com/](https://www.sequelpro.com/) and click on the download link.  Open the file you just downloaded and drag the Sequel Pro icon to your "Applications" folder.

###Install Putty For Windows

Because we want to run commands in our VM, we need a way to log into it.  On OS X and Linux, there are tools built in for us to do that and Vagrant handles it for us.  On Windows however, the same tools don't exist so we need to use something else.  We are going to use a program called PuTTY which will let us log into our VM.  I'll cover what I'm talking about more in detail later, but for now, if you are running Windows, you need to install PuTTY.

Go to [http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html](http://www.chiark.greenend.org.uk/~sgtatham/putty/download.html) and click the link that says "putty.exe".  There is no installer for Putty and instead put the downloaded file somewhere easy to access (where you put plink.exe).  This file opens Putty.

###Install Chrome Browser

The default web browsers on Windows and OS X (Edge & Safari) are good for browsing the web, but lack developer tools we need. Instead, we need to use either Chrome or Firefox. My personal favorite is Chrome so we are going to use it in this course.

Go to [https://www.google.com/chrome/browser/desktop/index.html](https://www.google.com/chrome/browser/desktop/index.html) and download Chrome.  Run the installer when it finishes downloading.
