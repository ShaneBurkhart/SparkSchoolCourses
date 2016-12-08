---
layout: default
permalink: /courses/twitter-clone/7/2
title: 7.2 Creating User Authentication Middleware
course: Twitter Clone
section: 'Day 7: Restrict Updating And Deleting Tweets'
next-lesson-link: /twitter-clone/7/3
---

####Table Of Contents

- [7.1 Saving Created Tweets In Cookies](/courses/twitter-clone/7/1)
- **7.2 Creating User Authentication Middleware**
- [7.3 Hiding Tweet Edit Link](/courses/twitter-clone/7/3)

In the last lesson, we added created tweet ids to a cookie, but right now, we aren't checking these ids to see if the user can edit the tweet.  We are going to use middleware to do this.

Middleware is simply some code that gets executed before our route gets executed.  This is useful for things that need to happen on every request like logging and user authentication.  We are already using cookie-parser and body-parser middleware that parses cookies and the request body on every request.

The middleware that we are already using is executed on every request but you can add middleware to only specific requests.  We are going to add user authentication middleware to the edit, update and delete routes since those are the only routes that need user authentication.

The authentication middleware will check that the tweet id we are trying to access is in our “tweets_created” cookie.  If it's not, then we will redirect to the homepage since the user shouldn't be able to access the edit tweet page.

Let's start by creating a new directory in the root of our project called “middleware”.  This will hold any middleware files.  Our middleware is going to authenticate users, so we'll call our file “auth-user.js”.  Create this file in the “middleware” directory.  Add the following contents to the file and I'll explain what's going on in a minute.

```javascript
// middleware/auth-user.js
'use strict'

module.exports = function(req, res, next) {
};
```

We are going to need this file in “app.js” so we'll be importing it in a minute.  First, we need to understand how you export things in node.js.  To export something in node.js, you assign what you want to export to “module.exports”.  This can be anything (function, object, array, etc). In the above code, we are exporting a function with three parameters.

Now when we require this file in “app.js”, the require function will return what “module.exports” was set to for that file.  Let's require “auth-user.js” in “app.js”.  We'll put this under the requires for other middleware.

```javascript
// app.js
var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var authUser = require('./middleware/auth-user');
var moment = require('moment');
```

The require function can also be given file paths to import javascript files that aren't in a library.  The period at the beginning means current directory that “app.js” is in, then the middleware subdirectory, and then the auth-user file in there.  Node is smart enough to figure out the file extension so we don't need to add it.  Now the “authUser” variable will be set to the function with three parameters in “auth-user.js”.

Although our authentication middleware doesn't do anything yet, let's add it to the edit and update routes.  To do this, we add a parameter to “app.get” and “app.post”.  Both of the methods take a path to listen for as the first argument and then any number of functions as arguments after.  These functions will be executed in the order they are given to “app.get” or “app.post” and the last argument should always be the route handler.

Let's add the “authUser” middleware as the second argument to the edit and update routes.  The third argument is now our route handler.

```javascript
// app.js
app.get('/tweets/:id([0-9]+)/edit', authUser, function(req, res) {
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

app.post('/tweets/:id([0-9]+)/update', authUser, function(req, res) {
  var updateQuery = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var deleteQuery = 'DELETE FROM Tweets WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;
  var isDelete = req.body.delete_button;
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

Currently, if you restarted your server and try to visit the edit page, your browser would keep loading until it times out.  This is because we haven't done anything in our middleware yet.  We are going to add a simple “console.log” to understand how middleware works.  I'll explain what's going on in a minute.

```javascript
// middleware/auth-user.js
module.exports = function(req, res, next) {
  console.log('This is middleware');
  next();
};
```

If you notice, our middleware function looks a lot like our route handler.  The difference is that the middleware function has a third parameter called “next”.  In Express, middleware works in a chain of sorts.  The first middleware is called and is passed a request object, a response object and the next middleware function to be called as the third parameter.  So the first middleware calls the second, which calls the third, and so on.

Without calling the “next” function, the middleware chain won't be continued.  Since we weren't calling the next middleware in the chain, we were causing the request to timeout.  We'll talk a little more about how we can use this later, but for now, we just want to output the text “This is middleware” and call the next middleware.

Restart your server and visit an edit tweet page.  You should see the text “This is middleware” printed in the terminal.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/7/7-2-logging-middleware.png)

We now know our middleware is working, so let's check if the tweet id is in the “tweets_created” cookie.  We can get values from the request parameter just like we do in our route handlers.

```javascript
// middleware/auth-user.js
module.exports = function(req, res, next) {
  var id = parseInt(req.params.id, 10);
  var tweetsCreated = req.cookies.tweets_created || [];

  if(!tweetsCreated.includes(id)) {
    // Redirect to homepage if user didn't create tweet.
    res.redirect('/');
    return;
  }

  next();
};
```

The first thing we are doing is getting the tweet id from the parameters and getting the list of tweet ids created from the cookies.  The id parameter is text that contains the id, but we need it to be a number.  To convert text to a number, we can use the “parseInt” function.  It takes the text to parse as the first argument and the number base as the second.  We are giving it our id and passing it the number base of 10 since we want decimal.

For “tweetsCreated”, we are using the “or” operator again to ensure that the variable will be an empty array if the cookie hasn't been created yet.

Next we have an “if” statement that is checking if the “tweetsCreated” array includes the id of the tweet.  Arrays in javascript have a method “includes” that checks if the value passed is in the array.  It returns true if it is and false if it isn't.  The exclamation mark at the beginning of the check is the “not” operator.  The “not” operator simple changes true to false and false to true.

Since we only want to redirect to the homepage if the tweet id doesn't exist in the cookie, we need to use the “not” operator on the value returned from the “includes” method.  Our if statement will only be executed if the id is not in the “tweetsCreated” variable.

Inside the “if” statement, we are redirecting to the homepage (“/”) and are returning early so “next” isn't called.  Since we are redirecting, we want to stop the middleware chain early so the code doesn't get to our route handler.

Now if the “if” statement isn't executed, then the code will reach the “next” function call and the middleware chain will continue as normal.

Restart your server and let's test this.  Any tweet that was created before we added cookies should redirect you to the homepage when attempting to edit.  If you create a new tweet, and then try to edit it, you should see a form to edit the tweet.

We have now added some user authentication to our tweets, but the edit button still shows for each tweet.  In the next lesson, we are going to go over how to hide this for tweets the user can't edit.
