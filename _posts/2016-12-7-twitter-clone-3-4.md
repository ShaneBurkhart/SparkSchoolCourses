---
layout: default
permalink: /courses/twitter-clone/3/4
title: 3.4 Connecting The Tweet Form To Our Web Server
course: Twitter Clone
section: 'Day 3: Creating And Saving Tweets'
---

####Table Of Contents

- [3.1 Connecting To MySQL](/courses/twitter-clone/3/1)
- [3.2 Creating The Database And Tweets Table](/courses/twitter-clone/3/2)
- [3.3 Inserting Some Tweets Into Our Database](/courses/twitter-clone/3/3)
- **3.4 Connecting The Tweet Form To Our Web Server**

Now that we know how to create tweets, let's do that in code.  Earlier we created our tweet form, but it doesn't do anything yet.

If you remember, we gave our form the "/tweets/create" action and the "POST" method.  This means when the form is submitted, the browser will send a POST request, with the form data, to http://127.0.01:8080/tweets/create. I chose the "/tweets/create" path because when defining urls, it's good practice to define the resource you are going to be working on and then the action you are going to be doing.  We are going to be working on "tweets" and are going to "create" a tweet.

When you type a URL into the search bar, you are executing a GET request.  The search bar always executes a GET request but forms can send both GET and POST requests.

The request method we use depends on the purpose of our form.  We use POST requests when we are creating data and GET methods are used on things like a search form where data isn't being created but you still want user input.  Remember, POST requests are used when creating data and GET requests are used to read data (view a web page).

Right now we don't haven't anything that listens for a route with the POST method and the path "/tweets/create", so let's add that now.  Similar to the "get" method on the "app" variable, we use the "post" method to listen for POST requests.  Go to "app.js" and let's create a POST route to "/tweets/create" under our homepage route.

```javascript
// app.js
app.post('/tweets/create', function(req, res) {
  // Code to create tweets goes here.
  res.send('Creating tweet.');
});
```

Right now, we are outputting the text "Creating tweet." so we can test if everything is working.  Restart your server and try submitting the form on the homepage ([http://127.0.0.1:8080](http://127.0.0.1:8080)).  You should see "Creating tweet." on the page which means our form is connected to our server.

###Connecting To The Database In Code

Before we can have our POST route create tweets, we need to establish a connection to our database.  To do this, we need to install the MySQL driver for node. Run the following in your terminal. Don't forget "--no-bin-links" for Windows.

```bash
# Terminal logged into VM
npm install mysql --save
```

Now that the MySQL driver is installed, let's include it in our file.  It's a good idea to keep all imports together and at the top of the file, so we are going to add a "mysql" require above our "express" require.

```javascript
// app.js
var mysql = require('mysql');
var express = require('express');
```

The MySQL library is required, but we aren't connected to our database yet.  To create a connection, we use the "createConnection" method on the "mysql" variable.  The first argument is a Javascript object that contains connection details for our MySQL database.  I'll explain what a Javascript object is in a second but for right now, create a connection under the "app" variable.

```javascript
// app.js
var app = express();
var connection = mysql.createConnection({
  host: '127.0.0.1',
  user: 'vagrant',
  password: '',
  database: 'twitter'
});
```

An object is a data type in Javascript that holds key-value pairs and is defined with curly braces. It's a little confusing that curly braces are used to define function blocks and Javascript objects, but the key difference is that no keyword ("function") comes before the curly braces for objects.

Each key-value pair in an object is separated by commas.  In the above object, we are setting the "host" key to the text "127.0.0.1" and the key "user" to the text "vagrant", etc.

Object keys are text or numbers and aren't required to have quotes around them.  In our example above, we omitted the single quotes on the keys.  Object values can be anything: numbers, text, functions, other objects, etc.

You can access the value of a key on an object in two ways: the dot notation and the bracket notation.  We've already talked about the dot notation a little but didn't go into much detail.  When we have been using the dot notation to call methods, we were actually referencing a key on the object that has a function as a value.

So when we do "app.post()" we are actually getting the value of the "post" key on the "app" object and calling the value since it's a function.  If instead there was a "name" key that had a text value on the "app" variable, we can get that value with "app.name". We don't need parenthesis since we aren't calling a function.

The second way to get object values by key is with the bracket notation.  This is almost the same as the dot notation, but it's advantage is we can search for keys with variable values.  Both the second and third line would get the value of the "name" key.  The fourth line is how we could call the "post" function with the bracket notation.

```javascript
// Javascript Example
var nameKey = 'name';

app['name']
app[nameKey]

app['post']('/tweets/create', function(req, res) { });
```

Now that you understand objects a little better, let's get back to connecting to our database.  The "createConnection" function on the "mysql" object returns a connection object that has a "connect" method to initiate the connection to the database.  The only argument it takes is a callback function that gets executed when the connection has been made or there was an error.

```javascript
// app.js
connection.connect(function(err) {
  // Our code will go here
});
```

The connection callback has one parameter for an error if there was one.  If there wasn't an error, the parameter will be undefined.  For our function, we are calling that parameter "err".

Since there might be an error when connecting to the database, we need to check that the "err" parameter is undefined and decide what to do based on that.  If there is an error, we need to print the error to the terminal and stop our program.  If there aren't any errors, we want to print some text to tell us that we connected to our database and then start our web server.

We can do this check with "if" statements.  "If" statements let us make decisions based on whether or not what we give it passes a truth test.  Below is how we can check if the "err" variable exists and print the error if it does:

```javascript
// Javascript Example
if(err) {
  console.log(err);
}
```

"If" statements start with the "if" keyword followed by parenthesis.  If the value inside the parentheses is true, the block of code in the curly braces will get executed.  You can also have "else if" and "else" blocks.  We aren't going to use those right now, but you can read this [guide on "if" statements](http://www.w3schools.com/js/js_if_else.asp) if you want to know more.

Let's add an error check to our connection callback:

```javascript
// app.js
connection.connect(function(err) {
  if(err) {
    console.log(err);
  }
  console.log('Connected to the database.');
});
```

Now our database connection callback checks for an error and prints it if there was one.  Currently, the text "Connected to the database" will be printed even if there is an error because our function will keep executing after the "if" statement.  To return from a function before the end, we use the "return" keyword.  Let's add that to our "if" statement.

```javascript
// app.js
if(err) {
  console.log(err);
  return;
}
```

The code will now enter the "if" statement if there was an error, print that error, and then stop the functions execution. This solves the issue of the "Connected to the database." text always printing but our server still starts regardless of whether there was an error connecting to the database.

Since some of our routes need a database connection, we need to wait for the connection to connect successfully before we start our server.  Let's move the "app.listen()" call to our connection callback.  We'll add this below our "Connected to the database." line so our web server will only get started if there wasn't an error.  Your app.js file should now look like the following:

```javascript
// app.js
'use strict'

var mysql = require('mysql');
var express = require('express');
var app = express();
var connection = mysql.createConnection({
  host: '127.0.0.1',
  user: 'vagrant',
  password: '',
  database: 'twitter'
});

connection.connect(function(err) {
  if(err) {
    console.log(err);
    return;
  }

  console.log('Connected to the database.');

  app.listen(8080, function() {
    console.log('Web server listening on port 8080!');
  });
});

app.set('views', './views');
app.set('view engine', 'ejs');

app.use(express.static('./public'));

app.get('/', function(req, res) {
  res.render('tweets');
});

app.post('/tweets/create', function(req, res) {
  // Code to create tweets goes here.
  res.send('Creating tweet.');
});
```

Restart your web server in your terminal and you should see the following:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/connected-to-database-in-terminal.png)

###Saving The Tweet To The Database

We now have a connection to our database in "app.js", so let's get the form data and save our Tweet to the database.

The first thing we need to do is get the Tweet data from the form.  If you remember, we used a POST request to submit our form since it is creating data.  POST requests store form values in the body of the request and they are URL encoded.  We aren't going to go over the details of URL encoding, but just know it is a format we use to send data over the internet.  If you want to know more, you can see this [guide on URL encoding](http://www.w3schools.com/tags/ref_urlencode.asp).

Since the POST request body is URL encoded, we need to decode it with middleware so we can read our form values.  There is an Express library we need to install to do this called [body-parser](https://github.com/expressjs/body-parser).  Let's install that now.  Run the following command in your terminal.  Don't forget "--no-bin-links" for Windows.

```bash
# Terminal
npm install body-parser --save
```

Now that our library is installed, let's require it in our "app.js" file.  Under our express require, let's require the "body-parser" library and save it to a variable called "bodyParser":

```javascript
// app.js
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
```

Like we did with the static file middleware, we are going to call the "use" method and add our body-parser middleware.  The body-parser library provides various middlewares to decode request bodies of different encoding types but we only need the URL encoding middleware.  To get that, we call the "urlencoded" method on the bodyParser object and pass it an object containing options.

The only option we need to set is the "extended" option and we need to set it to "true".  Explaining this option is out of the scope of the course, but just know you need it when using the body-parser.  If you are curious, you can read about the ["extended" option here](https://github.com/expressjs/body-parser#extended). Under the line that adds our static middleware, add the URL encoded request body middleware:

```javascript
// app.js
app.use(express.static('./public'));
app.use(bodyParser.urlencoded({ extended: true }));
```

Our form values are now in a readable state, so let's get them in our POST route.  The body-parser library adds a "body" key on the request object that gets passed to our route.  We can use the dot notation to get the "body" value on the "req" object in our POST route. This will return an object containing our form values.

If you remember, each of our form inputs had a "name" attribute.  For our handle it was "handle" and for our tweet body, it was "body".  These are the keys we use to get each form value from the request body.  Let's get the handle and body form values and print them to the terminal.

```javascript
// app.js
app.post('/tweets/create', function(req, res) {
  var handle = req.body.handle;
  var body = req.body.body;

  console.log(handle);
  console.log(body);

  // Code to create tweets goes here.
  res.send('Creating tweets');
});
```

Restart your server visit [http://127.0.0.1:8080](http://127.0.0.1:8080).  Input some values in the Tweet form and submit the form.  If you look at your terminal, you should see your form values printed.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/printing-post-request-body-variables.png)

Now that we have our Tweet form values, let's insert them into our database as with the INSERT INTO query we used earlier.  The difference is this time we are going to do it in code.

To make our code easier to read, let's first create our query and save it to a variable called "query".  Add this line above our "handle" and "body" variables.

```javascript
// app.js
var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
var handle = req.body.handle;
var body = req.body.body;
```

The query looks very similar to the query we used earlier to insert a Tweet into our MySQL GUI, but the values are question marks instead of our Tweet values.  The questions marks are called parameters and the query is called a parameterized query.  The parameters will later be replaced by values we pass to it.

We could just put our "handle" and "body" values directly in the query, but that would be a security vulnerability since we would be putting user input directly in our code.  Any time we get input from the user, we need to sanitize it to make sure they can't do something malicious.

In our case, if we didn't use parameterized queries, we would be vulnerable to [SQL injection attacks](https://www.owasp.org/index.php/SQL_Injection).  We aren't going to go into detail on how this attack works, but the attack allows the user to get access to parts of the database they aren't supposed to have access to.

The bottom line is we need to make sure the input we get from the user is sanitized before we use it in our query.  MySQL will do that for us if we put question marks in the query where our user input will be added.  For us, that's the "handle" and "body" values.

To run queries in code, we use the "query" method on our "connection" variable we created earlier.  The "query" method always takes query text as the first argument.  The next argument is optional and is a list of values we are inserting into our query parameters.  For us, that is our "handle" and "body" variables.  The last parameter to the "query" method is always a callback that gets executed when the query finishes or there was an error.

Let's save our Tweet to the database.

```javascript
// app.js
app.post('/tweets/create', function(req, res) {
  var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
  var handle = req.body.handle;
  var body = req.body.body;

  connection.query(query, [handle, body], function(err) {
  });

  res.send('Creating tweets');
});
```

This code contains some stuff we haven't learned yet.  If you look at the second parameter to the "query" method, you will see square brackets with "handle" and "body" in them separated by commas.  This is called an [array](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Array) and is essentially a list of data.

Arrays are defined with square brackets and can contain any number of values.  These values can be accessed with bracket notation and giving the index you want to get in the bracket notation.  The indexes start at 0 so the first item in the array has an index of 0, the second has an index of 1, etc.  The code below shows how you would assign an array to a variable called "nums" and get the first and third value in the array.

```javascript
// Javascript Example
var nums = [4, 9, 10, 3];
nums[0]; // returns the number 4
nums[2]; // returns the number 10
```

Now we are creating the Tweet, but we aren't waiting for our query to finish before responding to the request with "Creating Tweets".  To do this, move that line into our "query" method callback.

```javascript
// app.js
app.post('/tweets/create', function(req, res) {
  var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
  var handle = req.body.handle;
  var body = req.body.body;

  connection.query(query, [handle, body], function(err) {
    res.send('Creating tweets');
  });
});
```

If you restart your server, visit [http://127.0.0.1:8080](http://127.0.0.1:8080) and submit the form, a Tweet will be inserted.  You can view this in your MySQL GUI by inspecting the Tweets table like we did in previous lessons.

You may notice that we aren't doing anything but sending back text when we create a tweet.  This isn't very user friendly and ideally we would send them back to the homepage so they can view their new tweet there (when we get around to rendering tweets).

When you go from one route to another, we call this a redirect.  Lucky for us, Express has a method on the request object called "redirect".  The first argument it takes is the URL we want to redirect to.  Since the page we want to redirect to is on the same domain, we can simply give it the root path "/" (homepage).

```javascript
// app.js
connection.query(query, [handle, body], function(err) {
  res.redirect('/');
});
```

Restart your server and submit the Tweet form again.  It should redirect you back to the homepage and you should see your Tweet appear in your MySQL GUI.

Lastly, we want to make sure to print any errors if they exist.  The first argument to the query callback is an error if it exists, otherwise, it's undefined.  Like we did in our connection callback, we need to check the "err" argument with an "if" statement and print the error if it exists. We want to redirect back to our homepage no matter what so no need to return early in the case of an error.

```javascript
// app.js
connection.query(query, [handle, body], function(err) {
  if(err) {
    console.log(err);
  }

  res.redirect('/');
});
```

That conclude day 3 of the Twitter clone course.  Today we connected to our database, got our Tweet form values and inserted our tweet into our database. This is the "C" (Create) in CRUD.  In the next day, we will cover the "R" (Read) of CRUD and will read the tweets from our database and render them on our homepage.

### Final Code

```javascript
// app.js
'use strict'

var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var app = express();
var connection = mysql.createConnection({
  host: '127.0.0.1',
  user: 'vagrant',
  password: '',
  database: 'twitter'
});

connection.connect(function(err) {
  if(err) {
    console.log(err);
    return;
  }

  console.log('Connected to the database.');

  app.listen(8080, function() {
    console.log('Web server listening on port 8080!');
  });
});

app.set('views', './views');
app.set('view engine', 'ejs');

app.use(express.static('./public'));
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', function(req, res) {
  res.render('tweets');
});

app.post('/tweets/create', function(req, res) {
  var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
  var handle = req.body.handle;
  var body = req.body.body;

  connection.query(query, [handle, body], function(err) {
    if(err) {
      console.log(err);
    }

    res.redirect('/');
  });
});
```
