---
layout: default
permalink: /courses/twitter-clone/4/2
title: 4.2 Reading The Tweet From The Database
course: Twitter Clone
section: 'Day 4: Showing Tweets'
next-lesson-link: /courses/twitter-clone/4/3
---

####Table Of Contents

- [4.1 Creating A Tweet In HTML/CSS](/courses/twitter-clone/4/1)
- **4.2 Reading The Tweet From The Database**
- [4.3 Rendering Tweets On Our Page](/courses/twitter-clone/4/3)

Our page now has a static tweet, but we still need to get our tweets from our database and pass them to our "tweet.ejs" template file so it can render them.

If you remember from day 3, we've been using a SELECT query to see the contents of our Tweet table.  The query we have been using is one of the simplest forms of the SELECT query and let's go over that now.

```sql
-- SQL Example
SELECT * FROM Tweets;
```

SELECT queries allow us to read data from the database and start with the SELECT keyword.  After that, we define what columns we want to get from the database.  The "*" says get all columns.  If we only wanted the id and body columns, we could do the following.  We separate the column names by commas.

```sql
-- SQL Example
SELECT id, body FROM Tweets;
```

After defining the columns we want, we put the FROM keyword followed by the table name that we want to get our data from.  Our table is named "Tweets" so we are going to get data from the Tweets table.

As I mentioned, this is the simplest form of the SELECT query and it gets all rows and columns in our Tweets table.  Since we want to order them by created_at, let's add the ORDER BY keyword to the end of our query.

```sql
-- SQL Example
SELECT * FROM Tweets ORDER BY created_at DESC;
```

The ORDER BY section usually goes at the end of a query and lets us order our data by a column.  After the ORDER BY keyword, we give the name of the column we want to order by.  After the column name, we either put ASC to sort in ascending order or DESC for descending order.  We are ordering by the "created_at" column and want to sort them in DESC order since we want the most recently created to come first.  This will be the query we use in our homepage route.

Let's execute this query in our homepage "/" route like we did in our create tweet route.  We'll also move the line that renders the "tweets.ejs" file to inside the query callback since the template will need the tweets from the query.  This time when we call the "query" method, we won't have any query parameters to pass.  Just the query and the callback.

```javascript
// app.js
app.get('/', function(req, res) {
  var query = 'SELECT * FROM Tweets ORDER BY created_at DESC';

  connection.query(query, function(err, results) {
    res.render('tweets');
  });
});
```

I set the query to a variable again since it's easier to read.  If you ever have code that is hard to read, it is usually a good idea to restructure how you are doing it so it's easier to read in the future.

We're now getting tweets, but as always, we need to check for errors and print them if they exist.  We still want to render our homepage if there is a query error so there's no need for the "return" keyword.

```javascript
// app.js
app.get('/', function(req, res) {
  var query = 'SELECT * FROM Tweets ORDER BY created_at DESC';

  connection.query(query, function(err, results) {
    if(err) {
      console.log(err);
    }

    res.render('tweets');
  });
});
```

The second parameter to the query callback contains the query results and we are naming that parameter"results".  This is an array (list) of rows from our database.  We can run through these with a thing called a loop.  Loops let us execute a block of code over and over until we tell it to stop.  The loop we are going to use is the "for" loop.  I'll give an example and then explain what's going on.

```javascript
// Javascript Example
for(var i = 0; i < 4; i++) {
  console.log(i);
}
```

For loops start with the "for" keyword followed by parenthesis that tell the loop how to execute.  After the parenthesis, we have curly brackets that contain the code block that will run on each iteration of the loop.

Inside the parenthesis, there are three parts separated by semicolons.  The first section gets executed before the loop executes for the first time.  In the above "for" loop, we are setting the variable "i" to the value 0.

The next section in the parenthesis is the test condition for whether the loop should run.  If it returns true, then the loop will execute.  Ours is checking if the "i" variable is less than 4.  If "i" is less than 4, the loop's code block will be executed and if "i" is 4 or greater, the loop stops and code execution continues under the for loop.

The third section in the parenthesis executes after every iteration.  Ours has the code "i++" which is incrementing the "i" variable by 1.  This is short for "i = i + 1;".

Based on what I just said, the for loop will print the number 0 to 3 and then stop execution.  If this doesn't make sense, you can walk through it.  On initialization, "i" gets set to zero.  The test condition is check and "i" is less than 4 so we execute the code block.  Our code is printing the variable "i" so it will print 0 on the first iteration.  After the first iteration, the third section in the parenthesis increments "i" so it will be 1 on the second iteration.  This pattern continues until the test condition is false.  That happens when "i" is 4 and the for loop will stop.

Let's use a for loop to go through our results.  I mentioned that our results parameter is an array of rows returned.  Arrays have a "length" property that will tell us how many items there are in the array.  We use the dot notation on our array as if we were getting the "length" value from an object.  The following will return how many results are in our array.

```javascript
// Javascript Example
results.length
```

We can use this value in our for loop's test condition to loop through our results.  Let's write a for loop that loop through all of our results and prints them.  We'll put this after our error check so we can see the results that are returned.

```javascript
// app.js
app.get('/', function(req, res) {
  var query = 'SELECT * FROM Tweets ORDER BY created_at DESC';

  connection.query(query, function(err, results) {
    if(err) {
      console.log(err);
    }

    for(var i = 0; i < results.length; i++) {
      console.log(results[i]);
    }

    res.render('tweets');
  });
});
```

Since the first item in an array has an index of 0, we check if "i" is less than the length of the array.

Assuming you inserted Tweets into your database earlier, you can restart your web server and load the homepage [http://127.0.0.1:8080/](http://127.0.0.1:8080/) to see our tweets get printed to our terminal.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/select-tweets-query-results.png)

As you can see, each row is an object containing the data for each tweet.  We'll need the for loop in our next lesson so we're going to leave it there for now.  I more wanted to show you what was returned by our query.

In the next lesson, we'll be passing these tweets to our "tweets.ejs" template and rendering them to the page.

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

app.use(express.static('public'));
app.use(bodyParser.urlencoded({ extended: true }));

app.get('/', function(req, res) {
  var query = 'SELECT * FROM Tweets ORDER BY created_at DESC';

  connection.query(query, function(err, results) {
    if(err) {
      console.log(err);
    }

    for(var i = 0; i < results.length; i++) {
      console.log(results[i]);
    }

    res.render('tweets');
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
```
