---
layout: default
permalink: /courses/twitter-clone/1/4
title: 1.4 Your First Javascript Program
course: Twitter Clone
section: 'Day 1: Getting Your Development Environment Setup'
next-lesson-link: /twitter-clone/1/5
---

This guide assumes you know nothing about programming so let's create and run our first program.  We are going to start with a very basic program that prints the text “Hello World!” to the terminal.  This will get your feet wet as well as ensure that everything is setup correctly for our project.

It's usually a good idea to test early and often.  Coding can become tedious if you try to do everything at once.  Instead, it's better to start small and basic, make sure everything is working, and then move onto the next step.  In this tutorial, you'll notice that we are constantly checking to see if the code we wrote works as we expected.  Mistakes and errors are part of programming, so don't get discouraged.

Let's get started.  Right now, the only thing in our project directory is our Vagrantfile.  We need another file that we can use to run our web server.  This file is going to be a javascript file called “app.js”.  The “.js” extension means it's a javascript file.

To create our file, go into your text editor and select File > New File as we did with our Vagrantfile.  Now select File > Save As and save the file in our project directory as “app.js”.  We now have a file to put our code in, let's write some code.

In the next section, we are going to go into more detail on javascript, but since we are mostly wanting to check if everything is working, type the following code in our “app.js” file and save.

```javascript
console.log('Hello World!');
```

“console.log” is a function we use to print things to the terminal.  In this case, we are printing the text “Hello World!”.  You can change the text in the single quotes to print different text to the terminal.

We now have our code written, so let's run it.  To run our program, we are going to use the terminal.  Let's go into more detail on how the terminal works first.

The terminal is simply a place where you can type and run text based commands.   For the most part, each line in the terminal is it's own command.  To execute a command, you type out the command you want to execute and press enter.

The first word is always the command we are running and the rest is extra arguments given to the command so it knows what you want it to run.

```bash
cd ~/Desktop/TwitterClone
```

The above terminal line is calling the “cd” (stands for change directory) command and is given the path to our project directory.  This changes our terminal's current working directory to be our project directory.

This brings me to my next point, the terminal has a current working directory which is the base for running commands.  As you saw above, we can change this directory with the “cd” command. You can see what your current working directory is by using the “pwd” command or look at the end of the terminal prompt.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/current-working-directory-in-terminal.png)

The cyan colored section of the terminal prompt is the current working directory.  For the example above, the current working directory is “/vagrant”.

The “~” path stands for the home directory.  When you open the terminal, your current working directory is normally the home directory. This is the directory for the current user.

Now that we know a bit about the terminal, let's get back to running our program.  First, let's navigate to our project directory in our VM.  Vagrant automatically links all of the files in our project directory to the '/vagrant' directory in our VM.  Navigate there now with the following command:

```bash
cd /vagrant
```

Now run the “ls” command to see the contents of the current working directory and you should see “app.js” and “Vagrantfile” listed.

To run javascript files, we use the “node” and give it the name of the file we want to run.  In our case, our file is called “app.js” so our command looks like:

```bash
node app.js
```

You should see the text “Hello World!” appear below the command.  We now know everything is setup correctly and we can start making our web server.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/printing-hello-world-in-the-terminal.png)
