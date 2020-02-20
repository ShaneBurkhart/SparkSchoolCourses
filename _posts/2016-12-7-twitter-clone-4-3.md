---
layout: default
permalink: /courses/twitter-clone/4/3
title: 4.3 Rendering Tweets On Our Page
course: Twitter Clone
section: 'Day 4: Showing Tweets'
---

#### Table Of Contents

- [4.1 Creating A Tweet In HTML/CSS](/learn/courses/twitter-clone/4/1)
- [4.2 Reading The Tweet From The Database](/learn/courses/twitter-clone/4/2)
- **4.3 Rendering Tweets On Our Page**

In the last lesson, we got our tweets from the database and saw how we can loop through them to get each tweet.  Now, let's pass these to our template.

The "render" method we call at the end of our query callback only specifies the template we want to render.  There is a second optional parameter that takes an object that is passed to our template file.  We can define whatever values we want to pass to our template.  Let's add that now and assign our "results" parameter to the "tweets" key on our data object.

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

    res.render('tweets', { tweets: results });
  });
});
```

Now inside our "tweets.ejs" template, we can reference the variable "tweets" to get our results array.  Let's go into our "tweets.ejs" template and loop through our results much like we did in our homepage route.

EJS is a template engine that allows us to run javascript code in HTML files.  So an EJS file is really just an HTML file that has a special syntax that lets us run javascript code in our template. I'm going to write a for loop in EJS below and explain it after.

```ejs
<!-- EJS Example -->
<% for(var i = 0; i < tweets.length; i++) { %>
  <p><%= tweets[i].body %></p>
<% } %>
```

The above code has a lot of symbols, but it's pretty easy to break down.  To run javascript code in EJS files, we put our javascript between "<%" and "%>".  The first line shows an example of how this works.  We define the start of our "for" loop block in EJS brackets.  We also close the "for" loop code block on the third line with the same brackets and a curly brace.  This looks just like our homepage route's loop, but we wrap the lines with EJS brackets.

Now every time this runs, the code and elements inside the for loop will be executed.  If we have 3 tweets, then you will see three paragraph tags appear.  Inside our paragraph element, we are outputting the tweet body.  Notice how this EJS tag starts with a "<%=" instead of just "<%".  The equals sign tells EJS to output whatever was returned inside the tags.  So in our case, we are getting the tweet with the index "i" and getting its body.  The body will be put in each of the paragraph elements.

These are really the two main EJS tags you will use.  There are a few others but they are used far less frequently so we won't go over them.  If you want to know more, check out the EJS site.

Now we know how to run javascript in EJS files, so let's run through our tweets and output the tweets HTML for each tweet filled in with correct values.  The code will look a bit different since I formatted the first paragraph element (the one containing the handle) to be on multiple lines.  This doesn't change any behavior of our file, it just makes it easier to read.

```ejs
<!-- views/tweets.ejs -->
<main>
  <form id="tweet-form" action="/tweets/create" method="POST">
    <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane">
    <textarea id="tweet-form-body" name="body" placeholder="What's happening?"></textarea>
    <button id="tweet-form-button">Tweet</button>
  </form>
  <% for(var i = 0; i < tweets.length; i++) { %>
    <% var tweet = tweets[i]; %>
    <article class="tweet">
      <p>
        <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
        <span class="light-grey"> - <%= tweet.created_at %></span>
      </p>
      <p><%= tweet.body %></p>
    </article>
  <% } %>
</main>
```

All I did here was substitute the hardcoded handle, body and created\_at values with EJS brackets outputting the appropriate values.  Since we would be getting "tweets[i]" a bunch, I saved this value to a variable called "tweets" at the beginning of each iteration.  We use the "tweet" variable to get each tweet's data.

Restart your server since we added the data object to our "render" method in "app.js".  Load the homepage [http://127.0.0.1:8080](http://127.0.0.1:8080) and you should see your tweets rendered with their values.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/rendered-tweets.png)

Our tweets feed is finally coming to life, but that date is plain nasty.  We want to put it into a much easier to digest format such as "18 minutes ago".  To do this, we are going to use a library called [Moment.js](http://momentjs.com/).
Moment.js is an extremely useful library that makes working with dates really easy.  As we have with other libraries we need to install it for our project. Don't forget "--no-bin-links" for Windows.

```bash
# Terminal logged into VM
npm install moment --save
```

With that library installed, let's require it in our "app.js" file.  Put this under the rest of our "require" calls to keep things organized.

```javascript
// app.js
var mysql = require('mysql');
var express = require('express');
var bodyParser = require('body-parser');
var moment = require('moment');
```

Moment.js is imported, so let's loop through our tweets and calculate the time from now for each tweet's "created\_at" value.  We'll add this time from now value to each tweet object as "time\_from\_now".  Our "for" loop in app.js will now look like the following.

```javascript
// app.js
for(var i = 0; i < results.length; i++) {
  var tweet = results[i];
  tweet.time_from_now = moment(tweet.created_at).fromNow();
}
```

The first thing we are doing is getting the tweet and saving it to a variable called "tweet".

Up until now, we have only used the dot notation to get values for keys on objects.  In javascript, you can also assign values to keys the same way you would a variable.  The second line in the for loop is setting the "time\_from\_now" key to the right side of the equals sign.

On the right side of the equals, we have our Moment.js code.  When importing Moment.js, we get a function that takes a date and returns a Moment.js date object.  The new Moment.js date has a lot of helper methods we can use to format and manipulate our date.  The method that will give us the time from now is the "fromNow" method.  This returns the date in a human friendly format like "18 minutes ago"

With our new value on each tweet, let's go back to our template and update our date to "time\_from\_now" instead of "created\_at".

```ejs
<!-- views/tweets.ejs -->
<p>
  <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
  <span class="light-grey"> - <%= tweet.time_from_now %></span>
</p>
```

Restart your server and refresh the homepage [http://127.0.0.1:8080](http://127.0.0.1:8080).  You should now see an easy to read date.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/human-readable-time-from-now.png)

We can now create tweets and see them get added to the page.  Try adding a tweet with our form and you should see it get added to the top of our tweets feed.

Today, we went over the "R" (Read) part of CRUD.  So far we can create tweets with our form and render tweets on our homepage.  This is really exciting, because our app is becoming interactive.  In day 5, we will go over the "U" (Update) and how we can edit these tweets after they are created.

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
```

```ejs
<!-- views/tweets.ejs -->
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="/css/site.css">
  </head>
  <body>
    <header></header>
    <main>
      <form id="tweet-form" action="/tweets/create" method="POST">
        <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane">
        <textarea id="tweet-form-body" name="body" placeholder="What's happening?"></textarea>
        <button id="tweet-form-button">Tweet</button>
      </form>
      <% for(var i = 0; i < tweets.length; i++) { %>
        <% var tweet = tweets[i]; %>
        <article class="tweet">
          <p>
            <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
            <span class="light-grey"> - <%= tweet.time_from_now %></span>
          </p>
          <p><%= tweet.body %></p>
        </article>
      <% } %>
    </main>
  </body>
</html>
```
