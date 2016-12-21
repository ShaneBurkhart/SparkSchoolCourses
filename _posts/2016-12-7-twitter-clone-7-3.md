---
layout: default
permalink: /courses/twitter-clone/7/3
title: 7.3 Hiding Tweet Edit Link
course: Twitter Clone
section: 'Day 7: Restrict Updating And Deleting Tweets'
---

####Table Of Contents

- [7.1 Saving Created Tweets In Cookies](/courses/twitter-clone/7/1)
- [7.2 Creating User Authentication Middleware](/courses/twitter-clone/7/2)
- **7.3 Hiding Tweet Edit Link**

In the last lesson, we implemented our middleware to restrict users from accessing tweets they didn't create.  In this lesson, we are going to remove the edit tweet link for tweets that the user didn't create.

The edit tweet links are rendered on the homepage route so we need to check if each tweet is editable there.  We are going to add an "isEditable" attribute to each tweet object in our existing loop.

Before we can do that, we need to get our "tweets_created" cookie and save it to a variable.  We are going to use the "or" operator again to make sure the "tweetsCreated" variable is an array.

```javascript
// app.js
app.get('/', function(req, res) {
  var query = 'SELECT * FROM Tweets ORDER BY created_at DESC';
  var tweetsCreated = req.cookies.tweets_created || [];

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
```

We already have a loop that is going through the tweets that are going to be rendered, so let's use that to check if each tweet is editable.

```javascript
// app.js
for(var i = 0; i < results.length; i++) {
  var tweet = results[i];

  tweet.time_from_now = moment(tweet.created_at).fromNow();
  tweet.isEditable = tweetsCreated.includes(tweet.id);
}
```

We are setting the "isEditable" attribute to the return value of "includes".  If the id is included in created tweets then it is editable, if it's not, then the user can't edit the tweet.

We have the "isEditable" attribute on each tweet, so let's go to our "_tweet.ejs" partial and add a check for "isEditable.

```ejs
<!-- views/_tweet.ejs -->
<article class="tweet">
  <p>
    <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
    <span class="light-grey"> - <%= tweet.time_from_now %></span>
  </p>
  <p><%= tweet.body %></p>
  <% if(tweet.isEditable) { %>
    <p><a href="/tweets/<%= tweet.id %>/edit">Edit</a></p>
  <% } %>
</article>
```

We are adding an "if" statement in EJS tags that checks the "isEditable" value on the tweet and renders the edit tweet link if it is editable.  If you restart your web server and visit your homepage, tweets that were created before cookies were added should not have an edit link.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/7/7-3-hidden-edit-links.png)

That concludes the Twitter clone course.  At the start of this course, you started with minimal to no knowledge and in 7 days, you learned the basics of building a web app.  With the knowledge from this course, you can now start building your own CRUD apps.

There is still a lot of learning to be done, but now you have a solid understanding of the basic concepts that go into building a web app.  Everything else you'll learn is simply adding complexity to what we have and figuring out how to solve the problems you come across.

I'm really excited that you made it all the way through the course and would love to know what you think.  Email me at shane@trysparkschool.com to let me know what you thought of the course.  I would appreciate any feedback and if you are interested, I can help point you in the right direction to continue your education.

Thanks for taking the course and I hope to hear from you soon!

### Final Code

```javascript
// app.js
'use strict'

var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var cookieParser = require('cookie-parser');
var authUser = require('./middleware/auth-user');
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
  var tweetsCreated = req.cookies.tweets_created || [];

  connection.query(query, function(err, results) {
    if(err) {
      console.log(err);
    }

    for(var i = 0; i < results.length; i++) {
      var tweet = results[i];

      tweet.time_from_now = moment(tweet.created_at).fromNow();
      tweet.isEditable = tweetsCreated.includes(tweet.id);
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

```ejs
<!-- views/_tweet.ejs -->
<article class="tweet">
  <p>
    <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
    <span class="light-grey"> - <%= tweet.time_from_now %></span>
  </p>
  <p><%= tweet.body %></p>
  <% if(tweet.isEditable) { %>
    <p><a href="/tweets/<%= tweet.id %>/edit">Edit</a></p>
  <% } %>
</article>
```
