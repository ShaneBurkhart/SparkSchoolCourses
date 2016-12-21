---
layout: default
permalink: /courses/twitter-clone/1/5
title: 1.5 Writing Your First Web Server
course: Twitter Clone
section: 'Day 1: Getting Your Development Environment Setup'
---

####Table Of Contents

- [1.1 Introduction](/courses/twitter-clone/1/1)
- [1.2 Installing Tools](/courses/twitter-clone/1/2)
- [1.3 Setup Your Project And Connect To Your VM](/courses/twitter-clone/1/3)
- [1.4 Your First Javascript Program](/courses/twitter-clone/1/4)
- **1.5 Writing Your First Web Server**

We're finally have everything set up and are ready to start creating a web server.  Before we can write our web server, we need to create a "package.json" file in the root of our project directory.  This file stores information about the project as well as keeps track of the Node.js libraries we want to install.

Libraries are also sometimes called packages.  Generally, libraries are other projects that people have made to help do a specific task.  We are going to use the Express.js library since it makes creating web servers much easier.

The "package.json" file is used by the "npm" terminal command which stands for Node Package Manager.  This command lets us manage the libraries we have installed as well as install new ones.  To create a package.json file, run the following command in the terminal in the root of our project directory.

```bash
# Terminal logged into VM
npm init
```

The command will prompt for various pieces of information.  You can press enter until the command is finished to use the defaults. When the command is done, it will have created a "package.json" file in the root of your project directory.

With npm initialized, we can install libraries for our project.  The first library we need is Express.js ([http://expressjs.com/](http://expressjs.com/)).  This is a pretty standard web server library in the Node.js community and makes it much easier to create web servers.

To install libraries, we use the "npm" command followed by the word "install" followed by the name of the library we want to install.  To tell npm we want to save this library in our package.json file, we add the "--save" option at the end.  Below is what this looks like for Express.js:

```bash
# Terminal logged into VM
npm install express --save
```

On Windows, when running "npm install" commands, you'll have to add "--no-bin-links" to the end of the command.  So the previous command on windows should look like the following.

```bash
# Terminal logged into VM
npm install express --save --no-bin-links
```

If you wanted to install the library only temporary, you can omit the "--save" portion and the library won't be saved to your package.json file.

If you open the package.json file, you should see "express" listed under "dependencies"

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/minimal-package-json.png)

When you run "npm install", npm creates a directory called "node_modules" in the root of our project.  This holds all of the installed packages for the project.

###How Do Web Servers Work

Before we can create a web server, we need to understand how it works.  Web servers run on a protocol called HTTP.  You may have seen "http" when copying a url.  When a url starts with "http" or "https", you know it's a request to a web server.  You don't need to know the specifics of HTTP, just know that it tells the browser how to communicate with the server.

I'm now going to explain how URLs work.  For our example, we are going to use http://trysparkschool.com.

As we just mentioned, the part before "://" is the protocol and in our case it's HTTP.

The part after the "://" is the domain name.  Domain names are aliases for IP address and were created so people don't have to remember IP addresses.

After the domain name, you'll sometimes see extra text and symbols.  These help identify specific pages and settings for the page.  The general rule of thumb is to make your home page your plain domain name and uses forward slashes to specify other web pages.  In our case, "trysparkschool.com" is our homepage and "trysparkschool.com/about" could be an about page.

What happens when we type this in the browser and press enter?  The browser uses the domain name to lookup what the server IP address is.

IP addresses uniquely identify computers on the internet.  No two computers can have the same IP address.

After finding the IP, it sends an HTTP request to the IP it found.  The server receives the request, fetches data it needs and creates a web page to return.  When it's done, it serves the HTML web page back to the browser.  We'll go over this more later, but this is simply a large text file that defines how the page should be rendered by the browser.  The browser then takes the HTML that was returned and renders it to the user.

Below is a diagram showing the client and server and how they make requests.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/server-client-http-request-diagram.jpg)

If you look at the diagram above, you can see there are two distinct computers to a web request: a web server and the client computer.  Some people will call the client computer the "frontend" and the web server the "backend".

###Writing Our Web Server

With a basic understanding of how a web server works, let's create one. Open your "app.js" and remove our previous code.  This will be the file that contains our web server.


Like most programming languages, javascript executes code line-by-line starting at the top.  The first line of all of our javascript files needs to say "use strict" wrapped in single quotes.

```javascript
// app.js
'use strict'
```

This enables strict mode which makes development a little more consistent and takes out some of the weird parts of javascript.  To read more about what strict mode does, you can read this [explanation of strict mode](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Strict_mode).

After that, we need to import the Express.js library we installed earlier and save it to a variable.  First, let's explain a bit about javascript.

One of the most common programming concepts is using variables.  Variables are simply used to store information for later.  Each variable has a data type such as numbers and text.

To define variables in javascript, we use the "var" keyword followed by the name we want to give to our variable. Below we are defining a variable called num:

```javascript
// Javascript Example
var num;
```

Most lines in Javascript end in a semicolon.  There are a few exceptions that we'll go over later, but for the most part, know that a line of Javascript code ends in a semicolon.

That only defines a variable, but right now it has a value of undefined since we haven't given it a value. We do that with the assignment operator (equals sign) followed by the value we want to assign to the variable.  In the code snippet below, we are assigning the value 3 to the variable "num":

```javascript
// Javascript Example
var num = 3;
```

If you want to see the value of a variable, you can use "console.log()" like we did earlier and instead of giving it text, give it the variable you want to output.  The following code would output the number "3" to the terminal.

```javascript
// Javascript Example
var num = 3;
console.log(num);
```

Now that we understand variables a bit, let's go over how to import libraries.  To import libraries into our file, we use the "require" function.

Functions are simply a section of code that can be executed over and over by name.  We use functions so we don't have to write the same code over and over. Instead we can write the function once and call it multiple times, thus removing duplicate code.

To call functions, we type the name of the function followed by parenthesis.  The parenthesis means we are calling it.

Inside the parenthesis, we can pass values and variables.  These are called arguments and functions can take any number of arguments.  Arguments let us specify options and data that the function can use on that function call.

Functions can also return values, but aren't required to.  This is useful when a function creates something or fetches a value.

A simple example of a function that takes arguments and returns a value would be an "add" function that takes two numbers and returns the sum.  In the code snippet below, we are calling the "add" function and assigning the return value to a variable called "sum".  The variable "sum" would now equal the number 7.

```javascript
// Javascript Example
var sum = add(2, 5);
```

Now that we understand how variables and functions work, let's use the "require" function to import the express library.

```javascript
// app.js
var express = require('express');
```

The Express library returns a function that doesn't take arguments and is used to create an Express app. Let's do that now under our express import:

```javascript
// app.js
var app = express();
```

We now have an "app" variable that we can use to configure our server.  Right now, it doesn't do anything, but we are about to change that.

In HTTP, each request has an HTTP method that helps define the intent of the web request.  The GET method is used to read data and is one of the most common request methods. Your browser uses this method when when requesting a web page.

When a server is listening for a specific URL and HTTP method, we call that a route.  For instance, a route could have a GET method to the "/" path, which would listen for the bare domain.  This is also called the homepage.

For our first page, we are going to define a route that listens for a GET request to the homepage.  As we mentioned earlier, the homepage is to the bare domain which is defined as the "/" path.

Before we can define a GET route, you need to understand how to call a Javascript method on a variable.  Certain variable types in javascript also have functions attached to them called methods.  These act similarly to calling a normal function but instead the variable we are calling the method on can be used inside the method.

Don't worry about this too much for right now, just know that you call methods on variables using the dot notation. The following calls the "get" method on the "app" variable using the the dot notation (the period):

```javascript
// Javascript Example
app.get();
```

Luckily with Express, creating a GET route can easily be done with the "get" method on our "app" variable.  The first argument to the "get" method is the path our route is listening for and the second is a function that get's executed when a request matches this route.  Let's define a GET request to the homepage ("/"):

```javascript
// app.js
app.get('/', function(req, res) {
  // Our code will go here
});
```

There are a few new things we haven't covered in the above code. First, we are passing an anonymous function as the second argument to the "get" method.

Anonymous functions act the same as regular function but don't have a name.  To define an anonymous function, we use the "function" keyword, followed by parenthesis.  In the parenthesis we have function parameters, separated by commas, which are names given to the arguments passed in.

Following the parentheses, curly braces define the body of the function.  This is where we put the code that the function will execute. To give us space to write code, we put curly braces on different lines.

Notice that there isn't a semicolon at the end of the first line.  Semicolons never come directly after an open curly brace.

The next new thing is the comment  in the function body.  Comments are code that gets ignored when the program executes.  Anything after a "//" is a line comment that will go until the end of the line.  Comments are useful to add clarification to code or quickly remove some code temporarily.  In our case, we are putting a note of what will go inside in the future.

This is only a single line comment and there are other types of comments.  To learn more about comments, visit [http://www.w3schools.com/js/js_comments.asp](http://www.w3schools.com/js/js_comments.asp).

Notice that the anonymous function has two parameters that Express passes in as arguments on each request.  The first is the parameter "req" (short for "request") and contains data about the request the server received.  The second is "res" (short for "response") which provides methods for sending data back to the server. Express adds methods to these variables to make things easier.

Our route doesn't do anything yet, but let's fix that.  Our goal here is to get the words "Hello world!" printed on a web page.  Luckily, the "res" variable has a "send" method that lets us send text back to the client.  It takes a single argument and prints that argument to the web page.  In our case, we are going to pass it the text "Hello world!".

```javascript
// app.js
app.get('/', function(req, res) {
  res.send('Hello world!');
});
```

We have our app created and a route defined, but we haven't written any code to start our server yet.  Before we do that, let's talk a little about ports.

IPs uniquely identify computers on the internet, and ports identify a specific channel on the computer.  Ports make it possible to run multiple servers on the same IP address since different ports won't cause them to conflict.

You can specify which port you want to make the request on in the URL.  To do this, put a colon after the domain name followed by the port number you want to request.  Below, we are requesting trysparkschool.com on port 3000.  If you visit that URL in the browser, you'll notice nothing happens since we don't have a server running on that port.

[http://trysparkschool.com:3000](http://trysparkschool.com:3000)

By default, HTTP is done on port 80 and your browser hides this from you.  Try requesting trysparkschool.com on port 80 and you will get the same results as when you don't specify the port.

Typically when developing and running our server locally, we don't listen on port 80.  This is a good idea for many reasons but primarily allows us to run multiple web servers on the same computer.

Now that we know a little about ports, let's write some code to have our server listen on port 8080. The "app" variable has a method called "listen" that tells the server to start listening for web requests.

```javascript
// app.js
app.listen(8080, function() {
  console.log('Web server listening on port 8080!');
});
```

The first argument is the port we want to run our web server on.  If you remember me mentioning earlier, I said we were going to run our server on port 8080.

The second argument is an anonymous function that gets run when the server starts listening for requests.  This is only called once when the server starts up.

When a function will be executed based on an event such as starting a server or getting a web request, we call that function a callback.  When the event executes, the function will be called back to.  Callbacks are very common in javascript.

We want to know when our server starts, so the The body of this function simply prints the text "Web server listening on port 8080!" to the terminal.  We do this so we know that our server has started successfully.

We used "console.log" earlier, but I didn't get a chance to explain it.  The "console" variable always exists and can be accessed at any time.  The "console" variable has a method called "log" that takes an argument and prints it to the termina.  This is useful for inspecting variable values and notifying us that things have happen.

Your final code should look like this:

```javascript
// app.js
'use strict'

var express = require('express');
var app = express();

app.get('/', function(req, res) {
  res.send('Hello world!');
});

app.listen(8080, function() {
  console.log('Web server listening on port 8080!');
});
```

###Starting The Server And Viewing The Page

Now we have our server written, let's run it. Save "app.js" and go to your terminal (remember we need to be logged into our VM and be in our project directory).

To run javascript files, we use the "node" command.  [Node.js](https://nodejs.org/en/) is a Javascript environment that runs Javascript code for us. The first option passed to the node command is the name of the file we want to run.  Let's run our "app.js" file.

```bash
# Terminal logged into VM
node app.js
```

You should see a screen similar to this:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/server-listening-on-port-8080.png)

Notice how the terminal appears to stop and you don't get a new line for a command.  This is because the server waits and listens continuously for web requests.  To stop the server and run commands, hold control and press the "c" key.  This is the interrupt key sequence and will stop nearly all programs in the terminal.

Now that our server is running, let's go to your browser and request our page.  Our server is running on our local computer and not an external IP, so we use a special internal IP called "localhost".  This IP address can be accessed with the name "localhost" or the IP address 127.0.0.1.  Let's request the localhost IP on port 8080.  Visit [http://127.0.0.1:8080](http://127.0.0.1:8080) in your browser.

When the page loads, you should see the words "Hello world!" printed on the screen.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/1/hello-world-web-app.png)

That concludes day 1 of the Twitter clone course.  Today, we got our development environment setup and wrote our first web server.  On day 2 we'll start writing some HTML and give our page some style.  Thanks for following along, and I'll see you in the next lesson.

### Final Code

```javascript
// app.js
'use strict'

var express = require('express');
var app = express();

app.get('/', function(req, res) {
  res.send('Hello world!');
});

app.listen(8080, function() {
  console.log('Web server listening on port 8080!');
});
```
