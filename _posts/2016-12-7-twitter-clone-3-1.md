---
layout: default
permalink: /courses/twitter-clone/3/1
title: 3.1 Connecting To MySQL
course: Twitter Clone
section: 'Day 3: Creating And Saving Tweets'
next-lesson-link: /twitter-clone/3/2
---

####Table Of Contents

- **3.1 Connecting To MySQL**
- [3.2 Creating The Database And Tweets Table](/courses/twitter-clone/3/2)
- [3.3 Inserting Some Tweets Into Our Database](/courses/twitter-clone/3/3)
- [3.4 Connecting The Tweet Form To Our Web Server](/courses/twitter-clone/3/4)

Welcome to day 3 of the Twitter clone course.  Today we are going to connect the Tweet form we made in the last lesson to our server and save the Tweet to our database.

This is exciting stuff because this is what separates web apps from basic websites.  Basic websites serve serve static pages that never change while web apps serve pages that are populated with data that the user can create, read, update and destroy.

If you think about any piece of data, there are really only four actions that can be done on it: create, read, update, and destroy.  These four actions are the basis of all web apps and we use the acronym CRUD (Create Read Update Destroy) for short.

If you know how to write a basic CRUD app, you can build just about any web app you want.  Of course, some apps are more complex than others, but at the basis, you will find that it comes back to the CRUD principles.

Each of the next four days of the course are going to be used to explain one of the four letters in CRUD.  Today, we are going to start with the “C” and learn how to create data in a database.  Before we can create any data, we need to understand a little bit about databases.

###Connect To MySQL

The first thing we to do is connect to our MySQL server we have running in our VM. It starts running at boot so you don't need to do anything but log into the VM to get it running.  To connect to the MySQL server, we are going to use the MySQL GUI we installed in day one (Sequel Pro or HeidiSQL).

Since our GUI application is running on the host machine, we need to deal with different operating systems again.  Scroll down to find the instructions for your operating system.

####Windows

Open the HeidiSQL program we downloaded earlier. You should see a screen that looks like the following.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/heidisql-session-creation.png)

Click the button that says “New” to create a new session.  You'll see a window like the following appear.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/creating-new-session-in-heidisql.png)

Under “Network type” select “MySQL (SSH tunnel) since we are going to use SSH to connect to our MySQL server running in our VM.  Our “Hostname/IP” should be “127.0.0.1”.  The user should be “vagrant” and the password should be blank.  The port should be 3306.


Now go to the “SSH Tunnel” tab to configure our SSH credentials. You should see a screen like the following:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/config-ssh-for-heidisql.png)

In the “plink.exe location” we need to give the location of the plink.exe file we downloaded earlier.  Click on the little folder magnifying glass icon to the right of the box.  Find your plink.exe file and click open.


For “SSH host + port” put 127.0.0.1 in the first box and 2222 in the second.  The “Username” and “Password” should both be “vagrant”. Click the open button and select yes for any popups that come up.  You should now be connected and see a screen like the following.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/heidisql-open-session-screen.png)

Click on the “Query” tab in the upper middle part of the screen.  This will open a window where you can run SQL queries on the database.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/heidisql-query+panel.png)

In the rest of the course, I'm going to mention running the SQL command in your MySQL GUI.  To run SQL queries in HeidiSQL you click the command you want to run and press ctrl-shift-F9.  Remember, semicolons mark the end of a command, so keep that in mind when selecting commands.

####OS X

Open Sequel Pro and you should see a screen asking you for connection details.  Click on the “SSH” tab and fill out the form with the following info:

Name: Twitter Clone
MySQL Host: 127.0.0.1
Username: vagrant
SSH Host: 127.0.0.1
SSH User: vagrant
SSH Password: vagrant
SSH Port: 2222

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/sql-pro-login-screen.png)

Press the “Test connection” button and if it succeeds, click “Add to Favorites” so you can get to it quickly in the future.  You should see “Twitter Clone” appear on the left hand side under “FAVORITES”.  This saves your connection configuration so you can click the “Twitter Clone” favorite to fill it in quickly.

Click the “Connect” button and your screen should look like this:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/sequel-pro-query-tab.png)

As you can see at the top, we are in the “Query” tab.  In this tab, we can run SQL code on the MySQL server we are logged into.

In the rest of the course, I'm going to mention running the SQL command in your MySQL GUI.  To run SQL queries in Sequel Pro, click on the command you want to run and press cmd+r.  Remember, semicolons mark the end of a command, so keep that in mind when selecting commands.

####Linux

I doubt many people taking this course are on Linux, but if you are, send me an email at shane@trysparkschool.com and I'll help you get set up with a MySQL GUI.
