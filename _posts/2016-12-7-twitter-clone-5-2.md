---
layout: default
permalink: /courses/twitter-clone/5/2
title: 5.2 Getting Our Tweet From The Database
course: Twitter Clone
section: 'Day 5: Editing Tweets'
next-lesson-link: /twitter-clone/5/3
---

####Table Of Contents

- [5.1 Adding An Edit Link To Tweets](/courses/twitter-clone/5/1)
- **5.2 Getting Our Tweet From The Database**
- [5.3 Creating An Edit Tweet Page](/courses/twitter-clone/5/3)
- [5.4 Updating The Tweet In The Database](/courses/twitter-clone/5/4)

In the last lesson, we created a link to our edit tweets page, but the tweet page currently only renders the id param in the URL.  Let's get our tweet from the database so we can pass it to our view.

Previously we have been getting all tweets from the Tweets table with a SELECT query.  We'll use this same query to get a single tweet, but we are going to add a filter to get only the tweet with the id we want.

```sql
-- SQL Example
SELECT * FROM Tweets WHERE id = 1;
```

To do this, we add a WHERE clause to the end of our query.  The WHERE clause allows us to find all rows that match the given requirements.  In the above, we are selecting rows where the id is equal to the given parameter.  Ids uniquely identify rows so this should only return a single row.  The above gets the row with the id of 1.

Since an id is taken from a URL and URLs are user input, we need to let MySQL sanitize the input.  We do this with query parameters and need to replace the a 1 above with a question mark.

```sql
-- SQL Example
SELECT * FROM Tweets WHERE id = ?;
```

Let's execute this query and pass our tweet id as a parameter. We'll print the tweet to the terminal so we can see what's returned.

```javascript
// app.js
app.get('/tweets/:id([0-9]+)/edit', function(req, res) {
  var query = 'SELECT * FROM Tweets WHERE id = ?';
  var id = req.params.id;

  connection.query(query, [id], function(err, results) {
    res.send(id);
  });
});
```

As always, we need to check for query errors.  For our edit page, when there is an error, we want to redirect to our homepage.  It doesn't make sense to render an edit page if there was an error when getting our tweet.

```javascript
// app.js
connection.query(query, [id], function(err, results) {
  if(err) {
    console.log(err);
    res.redirect('/');
    return;
  }

  res.send(id);
});
```

The above is checking for an error, printing the error to the terminal, redirecting to the homepage and then returning from the query callback since we don't want to execute the code below.

What if our query doesn't return a tweet?  If we don't find a tweet, it doesn't make sense to render a edit tweet page since there is nothing to edit.  So in that case, we want to also redirect to the homepage.

We don't need to create a new “if” statement since the one we have does what we want for no tweet as well.  Let's do that with the “or” operator.

```javascript
// app.js
if(err || results.length === 0) {
  console.log(err || 'No tweet found.');
  res.redirect('/');
  return;
}
```

There are a few new things in the above “if” statement that we need to go over.  The first thing is what's in the “if” statement's parentheses.  The “||” is the “or” operator and allows us to make more complex decisions.  What this says is if “err” exists OR “results.length” is zero then execute the code.  The “===” returns true if both sides of the “===” are the same.  It equates to  false otherwise.

Now let's go to the second line.  We are again using the “or” operator, but in a slightly different way.  In this case, we are giving default text to output if “err” doesn't exist.  If “err”' exists, “console.log()” will be passed the “err” variable.  If the “err” variable is undefined, then the text 'No tweet found.' will be passed to “console.log()” instead.

Restart your server and visit a tweet edit page for an id that doesn't exist yet.  Assuming you don't haven't created many tweets, visit http://127.0.0.1:8080/tweets/1000/edit and it should redirect to the homepage.

Alright, we have our errors and no tweet cases handled.  Let's render an EJS file instead of sending back the id parameter. We'll also pass our tweet to the view since we'll need it in there.

```javascript
// app.js
connection.query(query, [id], function(err, results) {
  if(err || results.length === 0) {
    console.log(err || 'No tweet found.');
    res.redirect('/');
    return;
  }

  res.render('edit-tweets', { tweet: results[0] });
}
```

We're rendering the 'edit-tweets' view and giving it the first result from our query since our results should only contain a single row.  The 'edit-tweets' EJS file doesn't exist yet, but we'll create it in the next lesson.
