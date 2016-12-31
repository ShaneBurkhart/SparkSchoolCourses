---
layout: default
permalink: /courses/twitter-clone/7/1
title: 7.1 Saving Created Tweets In Cookies
course: Twitter Clone
section: 'Day 7: Restrict Updating And Deleting Tweets'
next-lesson-link: /courses/twitter-clone/7/2
---

####Table Of Contents

- **7.1 Saving Created Tweets In Cookies**
- [7.2 Creating User Authentication Middleware](/courses/twitter-clone/7/2)
- [7.3 Hiding Tweet Edit Link](/courses/twitter-clone/7/3)

***Make sure you are logged into Vagrant before starting today's lessons.*** <a href="/guides/logging-into-vagrant" target="_blank">Click here to view the "Logging Into Vagrant Guide"</a>

Welcome to day 7 of the Twitter clone course.  Yesterday, we added a delete button for our tweets and deleted them from the database.  Today, we are going to add a little user authentication so only the computer that created the tweet can edit the tweet. Let's get started.

HTTP is stateless which means each request is isolated and doesn't know about any other request.  This makes it hard to associate requests with a specific user since each request only knows what we pass to it and not what happened on other requests. Because we need a way to keep track of which requests belong to each user, we use cookies.

Cookies are simply data that is stored in the user's browser. At minimum, each cookie contains a name and a value.  For instance, we might have a cookie named "user\_id" that stores the id of the user that is logged in.

On each request, the browser will send all of the cookies for the domain to the web server.  The web server then uses these cookies for data that is specific to the user.  In the case of the "user\_id" cookie, the web server would use that id to get the user's information from the database.

Web servers can also set cookies in the browser.  To do this, the web server sends back the cookies to set on the response and the browser will update its cookies. Each browser on a computer has it's own set of cookies.  So a cookie is not only specific to a computer, but also to a browser on that computer.

For this course, we don't have users, so we are going to store the ids of tweets that were created.  We'll give our cookie the name "tweets\_created" and it's value will be a list of ids.  We can use these ids to check if the user created the tweet they are trying to edit, update, or destroy.

Before we can start using cookies, we need to add middleware to parse cookies.  This middleware is called [cookie-parser](https://github.com/expressjs/cookie-parser) and it works much like body-parser.  Let's install the cookie-parser library now.  Remember to add "--no-bin-links" if you are on Windows.

```bash
# Terminal logged into VM
npm install cookie-parser --save
```

With that installed, let's require the cookie-parser library under our body-parser library.

```javascript
// app.js
var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var moment = require('moment');
```

To get the middleware and add it to our app, we simply call the "cookieParser" function, which returns the middleware, and pass it to "app.use".

```javascript
// app.js
app.use(express.static('./public'));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(cookieParser());
```

Now on each request, Express will parse cookies for us and add them to the request object with the key "cookies".  The "cookies" object contains name-value pairs with the name of the cookie being the key.  To get our "tweets\_created" cookie value, we can do the following.

```javascript
// Javascript Example
req.cookies.tweets_created
```

With that out of the way, we need to start by saving the id of newly created tweets in a the "tweets\_creatd" cookie.  We'll add this to the create tweet route.

Each time the user creates a tweet, we need to get the "tweets\_created" cookie, add the new tweet id, and then set the "tweets\_created" cookie to the new list.  Let's add the code to get the tweets created and save it again to the "tweets\_created" cookie.

```javascript
// app.js
app.post('/tweets/create', function(req, res) {
  var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
  var handle = req.body.handle;
  var body = req.body.body;
  var tweetsCreated = req.cookies.tweets_created || [];

  connection.query(query, [handle, body], function(err) {
    if(err) {
      console.log(err);
    }

    res.cookie('tweets_created', tweetsCreated, { httpOnly: true });
    res.redirect('/');
  });
});
```

We are using the "or" operator when setting the "tweetsCreated" variable.  We are doing this because the first time a user creates a tweet, there won't be any cookies set since they haven't created a tweet yet.  This means that the "tweets\_created" cookie will be undefined.  Since we want the cookie to be an array, we are using the "or" operator to set "tweetsCreated" to an empty array if the "tweets\_created" cookies doesn't exist.  If the "tweets\_created" cookie does exist, then the empty array gets ignored and "tweetsCreated" is the array from the cookie.

In the query callback, just before the redirect, we are setting our "tweets\_created" cookie.  We set cookies with the "cookie" method on the response parameter.  The first parameter to the "cookie" method is the name of the cookie and the second is the value the we are giving the cookie.  There is a third optional parameter, that takes an object with [options for the cookie](http://expressjs.com/en/api.html#res.cookie).  In this object, we can set things like expiration date and domain name that the cookie applies to.

For our cookie, we are setting the "httpOnly" option to true.  This option makes it so the cookie can only be accessed by the web server and not by client side javascript.  Don't worry about this too much.  Just know that the having this option set means that only our web server can read the cookie.

We are setting our cookie, but we aren't adding ids to our "tweetsCreated" array.  To do this, we need the id of the tweet that was just created.  There is a second parameter that is passed to our INSERT INTO query callback that contains the inserted id. Let's add that parameter and call it "results".

```javascript
// app.js
connection.query(query, [handle, body], function(err, results) {
  if(err) {
    console.log(err);
  }

  res.cookie('tweets_created', tweetsCreated, { httpOnly: true });
  res.redirect('/');
});
```

The "results" parameter is an object that has a key called "insertId" that contains the id that was just inserted.  Let's get that id and add it to our "tweetsCreated" array.

```javascript
// app.js
app.post('/tweets/create', function(req, res) {
  var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
  var handle = req.body.handle;
  var body = req.body.body;
  var tweetsCreated = req.cookies.tweets_created || [];

  connection.query(query, [handle, body], function(err, results) {
    if(err) {
      console.log(err);
    }

    tweetsCreated.push(results.insertId);
    res.cookie('tweets_created', tweetsCreated, { httpOnly: true });

    res.redirect('/');
  });
});
```

To add a value to an array, we use the "push" method on the array.  The "push" method takes a single argument which is the value we want to add.  In our case we are adding the id of the tweet we just inserted.

Now if you restart your server and create a tweet, the tweet id will be in a cookie called "tweets\_created".  You can see the cookies for a site using the Google Chrome Developer Console.

I talked about the Chrome Developer Console a bit earlier when we were working with HTML and CSS.  To open the console, go to a chrome tab and right click on the page.  You should see an option that says "Inspect" or "Inspect Element".  Click that and the developer console will open.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/7/7-1-inspect-element-option.png)

Go to the "Application" tab and there should be an item in the left hand column that says "Cookies".  Open the drop down, and select "http://127.0.0.1:8080".  In the right table, you will see the cookies for the site.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/7/7-1-chrome-dev-tools.png)

If you have created a tweet since adding cookies, you should see a cookie with the name "tweets\_created" and it should have a value.  The value is URL encoded so it's a little hard to read.  You should be good as long as the value isn't blank.

We now have created tweet ids being saved in cookies, but we aren't checking those ids to see if the user can edit a tweet.  To do this, we are going to use middleware.  In the next section, we are going to be going over middleware and how to create your own.

### Final Code


```javascript
// app.js
'use strict'

var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var moment = require('moment');
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
app.use(cookieParser());

app.get('/', function(req, res) {
  var query = 'SELECT * FROM Tweets ORDER BY created_at DESC';

  connection.query(query, function(err, results) {
    if(err) {
      console.log(err);
    }

    for(var i = 0; i < results.length; i++) {
      var tweet = results[i];
      tweet.time_from_now = moment(tweet.created_at).fromNow();
    }

    res.render('tweets', { tweets: results });
  });
});

app.post('/tweets/create', function(req, res) {
  var query = 'INSERT INTO Tweets(handle, body) VALUES(?, ?)';
  var handle = req.body.handle;
  var body = req.body.body;
  var tweetsCreated = req.cookies.tweets_created || [];

  connection.query(query, [handle, body], function(err, results) {
    if(err) {
      console.log(err);
    }

    tweetsCreated.push(results.insertId);
    res.cookie('tweets_created', tweetsCreated, { httpOnly: true });

    res.redirect('/');
  });
});

app.get('/tweets/:id([0-9]+)/edit', function(req, res) {
  var query = 'SELECT * FROM Tweets WHERE id = ?';
  var id = req.params.id;

  connection.query(query, [id], function(err, results) {
    if(err || results.length === 0) {
      console.log(err || 'No tweet found.');
      res.redirect('/');
      return;
    }

    var tweet = results[0];
    tweet.time_from_now = moment(tweet.created_at).fromNow();

    res.render('edit-tweet', { tweet: tweet });
  });
});

app.post('/tweets/:id([0-9]+)/update', function(req, res) {
  var updateQuery = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var deleteQuery = 'DELETE FROM Tweets WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;
  var isDelete = req.body.delete_button !== undefined;
  var queryCallback = function(err) {
    if(err) {
      console.log(err);
    }

    res.redirect('/');
  };

  if(isDelete) {
    // Our delete code goes here.
    connection.query(deleteQuery, [id], queryCallback);
  } else {
    // The update button was pressed.
    connection.query(updateQuery, [body, handle, id], queryCallback);
  }
});
```
