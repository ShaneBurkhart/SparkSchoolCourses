---
layout: default
permalink: /learn/courses/twitter-clone/5/4
title: 5.4 Updating The Tweet In The Database
course: Twitter Clone
section: 'Day 5: Editing Tweets'
---

####Table Of Contents

- [5.1 Adding An Edit Link To Tweets](/learn/courses/twitter-clone/5/1)
- [5.2 Getting Our Tweet From The Database](/learn/courses/twitter-clone/5/2)
- [5.3 Creating An Edit Tweet Page](/learn/courses/twitter-clone/5/3)
- **5.4 Updating The Tweet In The Database**

In the last lesson, we added a tweet preview and edit form to our edit tweet page, but our form submits to a route that doesn't exist yet.  In this lesson, we'll be making that route and updating the tweet in the database.

Let's create a POST route with the "/tweets/:id/update" path.  I'm going to put this under our edit tweet route.  It's a good idea to keep edit and update routes close since they work together.

```javascript
// app.js
app.post('/tweets/:id([0-9]+)/update', function(req, res) {
  var id = req.params.id;
});
```

I went ahead and saved the tweet id to a variable since we will use it in just a minute.

Before we can update our database, we need to understand the SQL UPDATE query.  Below, is a query that updates a tweet with the the id of 1.

```sql
-- SQL Example
UPDATE Tweets SET handle = 'DonkkaShane', body = 'Updated tweet.' WHERE id = 1;
```

UPDATE queries start with the UPDATE keyword followed by the name of the table we want to update.  Next is the SET keyword and the values we want to update come after separated by commas.  In the above example, we are setting the body to 'Updated tweet.' and the handle to 'DonkkaShane'.

After the SET clause, we can add an optional WHERE clause.  If we didn't have the WHERE clause, every row would be updated to the values we SET earlier.  The WHERE clause let's us define which rows we update.  In our case, we are updating the row with the id of 1.

As always, we are going to use query parameters for user input in our query.  Our query will end up looking like the following.

```sql
-- SQL Example
UPDATE Tweets SET handle = ?, body = ? WHERE id = ?;
```

Like in our create tweet route, let's get our tweet handle and body values from our request body.  We'll pass these and the tweet id to our query as parameters.  Let's do that now.

```javascript
// app.js
app.post('/tweets/:id([0-9]+)/update', function(req, res) {
  var query = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;

  connection.query(query, [body, handle, id], function(err, results) {
  });
});
```

This will update our tweet in the database, but as always, we need to check for errors and print them to the console.  There's no need to redirect on error because we are going to redirect to the homepage on error or success.  Let's add an error check and redirect to our homepage.

```javascript
// app.js
connection.query(query, [body, handle, id], function(err) {
  if(err) {
    console.log(err);
  }

  res.redirect('/');
});
```

Restart your server, go to the edit page and submit the form with updated values.  You should see your tweet update to the values given.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/5/5-4-updated-tweet-in-feed.png)

Today, we went over the "U" (Update) part of CRUD.  Our site is almost completely interactive since we can now create, read and update tweets.  The only thing left is the "D" (Delete).  In day 5, we will go over how we can delete tweets.

### Final Code

```javascript
// app.js
'use strict'

var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
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

  connection.query(query, [handle, body], function(err) {
    if(err) {
      console.log(err);
    }

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
  var query = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;

  connection.query(query, [body, handle, id], function(err) {
    if(err) {
      console.log(err);
    }

    res.redirect('/');
  });
});
```
