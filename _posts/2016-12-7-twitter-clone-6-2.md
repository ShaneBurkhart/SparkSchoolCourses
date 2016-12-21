---
layout: default
permalink: /courses/twitter-clone/6/2
title: 6.2 Removing The Tweet From The Database
course: Twitter Clone
section: 'Day 6: Deleting A Tweets'
---

####Table Of Contents

- [6.1 Adding A Delete Button](/courses/twitter-clone/6/1)
- **6.2 Removing The Tweet From The Database**

We now have a delete button to submit our update tweet form, but we haven't added a check for which button was pressed.  If the delete button was pressed, we want to delete the tweet and if not, we want to update the tweet.

To determine which button was pressed, we get the "delete\_button" value on our POST request body.  This is the same value we gave our name attribute on our delete button.  Let's get that now and save it to a variable called "isDelete" under our "body" variable.

```javascript
// app.js
var query = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
var id = req.params.id;
var handle = req.body.handle;
var body = req.body.body;
var isDelete = req.body.delete_button !== undefined;
```

The "!==" is the not equals operator.  We are making sure that the "delete\_button" key is not undefined.  If the update button was used to submit the form, the "delete\_button" variable will be undefined so "isDelete" will be false.  If the delete button was pressed, the "delete\_button" variable will be defined and "isDelete" will be true.

```javascript
// app.js
app.post('/tweets/:id([0-9]+)/update', function(req, res) {
  var query = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;
  var isDelete = req.body.delete_button !== undefined;

  if(isDelete) {
    // Our delete code goes here.
  } else {
    // The update button was pressed.
    connection.query(query, [body, handle, id], function(err) {
      if(err) {
        console.log(err);
      }

      res.redirect('/');
    });
  }
});
```

This checks if "isDelete" is true.  If it is, the code block that says "Our delete code goes here." will be executed.  The else block gets executed if the "isDelete" variable is false and will update our tweet.

Before we can write our delete query, let's go over how you delete rows in SQL.  We use the DELETE FROM query to delete rows.

```sql
-- SQL Example
DELETE FROM Tweets WHERE id = 1;
```

DELETE FROM queries start with "DELETE FROM" followed by the table we are deleting rows from.  We can add an optional WHERE clause to specify which rows should be deleted.

The above query is deleting all rows where the "id" column is 1.  Since ids are unique, there will only be one row deleted.  If we didn't add the WHERE clause, the query would delete all rows in our table.

Let's add this query to our update route as the variable "deleteQuery" and change the update query variable name to "updateQuery".  Don't forget to change the variable name we pass to the "query" method as well.

```javascript
// app.js
app.post('/tweets/:id([0-9]+)/update', function(req, res) {
  var updateQuery = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var deleteQuery = 'DELETE FROM Tweets WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;
  var isDelete = req.body.delete_button !== undefined;

  if(isDelete) {
    // Our delete code goes here.
  } else {
    // The update button was pressed.
    connection.query(updateQuery, [body, handle, id], function(err) {
      if(err) {
        console.log(err);
      }

      res.redirect('/');
    });
  }
});
```

As always, since our id is user input, we are using query parameters in our query's WHERE clause.

Let's execute the delete query in the first section of our "if" statement.  We'll pass it the id as a parameter.  The query callback will look the same as the one we used for the update query.

```javascript
// app.js
app.post('/tweets/:id([0-9]+)/update', function(req, res) {
  var updateQuery = 'UPDATE Tweets SET body = ?, handle = ? WHERE id = ?';
  var deleteQuery = 'DELETE FROM Tweets WHERE id = ?';
  var id = req.params.id;
  var handle = req.body.handle;
  var body = req.body.body;
  var isDelete = req.body.delete_button !== undefined;

  if(isDelete) {
    // Our delete code goes here.
    connection.query(deleteQuery, [id], function(err) {
      if(err) {
        console.log(err);
      }

      res.redirect('/');
    });
  } else {
    // The update button was pressed.
    connection.query(updateQuery, [body, handle, id], function(err) {
      if(err) {
        console.log(err);
      }

      res.redirect('/');
    });
  }
});
```

If you restart your server and submit the form with the delete button, the tweet will be deleted.  Our update route now has the behavior we want, but the query callback functions are identical.  Duplicate code is usually a sign that something can be cleaned up.  In our case, we can assign our anonymous function to a variable and pass that as the callback instead of the anonymous function.

```javascript
// app.js
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

We are now saving our anonymous function to a variable called "queryCallback" and passing that "queryCallback" variable to our "query" method as the callback.  This removes duplicate code and makes everything look much cleaner.

Our update route now updates and deletes rows in our table based on which form button was pressed.  Today's lesson is much shorter than the other CRUD methods because there isn't much to deleting data.  In day 7, we'll learn how to use cookies to restrict deleting and updating tweets to the user that created the tweet.

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
