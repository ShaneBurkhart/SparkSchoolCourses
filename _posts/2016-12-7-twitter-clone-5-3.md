---
layout: default
permalink: /courses/twitter-clone/5/3
title: 5.3 Creating An Edit Tweet Page
course: Twitter Clone
section: 'Day 5: Editing Tweets'
next-lesson-link: /courses/twitter-clone/5/4
---

####Table Of Contents

- [5.1 Adding An Edit Link To Tweets](/courses/twitter-clone/5/1)
- [5.2 Getting Our Tweet From The Database](/courses/twitter-clone/5/2)
- **5.3 Creating An Edit Tweet Page**
- [5.4 Updating The Tweet In The Database](/courses/twitter-clone/5/4)

In the last lesson, we got our tweet from the database and rendered the 'edit-tweet' EJS file, but that file doesn't exist yet.  Let's create an EJS file for our edit tweet page.  In the "views" directory, we are going to create a file called "edit-tweet.ejs" for our edit page.  Do that now and let's add the basic HTML structure for our site (header, css, etc.).

```ejs
<!-- views/edit-tweet.ejs -->
<!DOCTYPE html>
<html>
  <head>
    <link rel="stylesheet" type="text/css" href="/css/site.css">
  </head>
  <body>
    <header></header>
    <main>
    </main>
  </body>
</html>
```

Visit a tweet edit page and you'll see a blank page with a header.

Let's talk about what's going to go on this page.  When editing a resource, it's generally a good idea to give a preview of what it currently looks like and then a form to edit those values.  That means the first thing we need to add to our page is a tweet.  We've already created HTML/CSS for tweets, so no need to go over that again.

We could copy the tweet HTML from our homepage view into our edit tweet view, but this is generally bad practice.  If you have the tweet HTML in two places, anytime you want to make changes to a tweet, you have to update it in two places.  This can quickly cause inconsistencies and makes development tedious.

Instead, it would be better if we could have an EJS file that defines what a tweet looks like that we could use in both locations.  Luckily, EJS can do this by including other EJS files in our views.

Let's first create a file in our "views" directory that is called "_tweet.ejs".  Notice the "_" at the beginning of our files name.  It's generally good practice to put an underscore at the beginning of a file's name if that file only defines part of an HTML page.  Our "_tweet.ejs" is going to contain only a single tweet so we add an underscore at the beginning of the file name.  Files that define only a small portion of a page are called partials since it only contains part of a page.

Let's copy our tweet HTML into our "_tweet.ejs" file.

```ejs
<!-- views/_tweet.ejs -->
<article class="tweet">
  <p>
    <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
    <span class="light-grey"> - <%= tweet.time_from_now %></span>
  </p>
  <p><%= tweet.body %></p>
  <p><a href="/tweets/<%= tweet.id %>/edit">Edit</a></p>
</article>
```

Now that we have a tweet partial, let's update our homepage to use it.  EJS has a function we can use to include other EJS files that is called "include".  It follows the same pattern as our "res.render()" function.  The first argument is the name of the EJS file to include and the second argument is an optional data object to be passed to the partial.  Our tweets loop in "tweets.ejs" will now look like the following.

```ejs
<!-- views/tweets.ejs -->
<% for(var i = 0; i < tweets.length; i++) { %>
  <%- include('_tweet', { tweet: tweets[i] }); %>
<% } %>
```

We are still looping through the tweets the same but we are now including our tweet partial instead of having HTML.  We specify we want to include the "_tweet" partial and give a data object that contains the tweet to render.

The EJS tags around the "include" function call is different than we've done before.  The hyphen after the opening EJS tag indicates that we want to render HTML and not text.  If we used an equals sign instead of a hyphen, you would see the literal HTML code printed to the page rather than HTML elements.

If you refresh your homepage, you should still see each of the tweets being rendered.

Let's include the tweet partial in 'edit-tweet.ejs'.

```ejs
<!-- views/edit-tweet.ejs -->
<main>
  <%- include('_tweet', { tweet: tweet }); %>
</main>
```

We passed our tweet from the database to "edit-tweet" as "tweet".  We'll pass that to our partial as "tweet" as well.  Visit an edit tweet page and you should see a preview of the tweet you are editing.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/5/5-3-tweet-preview-on-edit-tweet-page.png)

The time since created is blank. This is because we didn't add it to the tweet in our edit tweet route.  Let's add that now.  Our final edit tweet route will look like the following.

```javascript
// app.js
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
```

Our tweet preview is good to go, but we need a form to edit the tweet values.  We could create a partial for our form, but I think the two forms are going to be different enough that it would be too complicated to deal with right now.  Let's copy our tweet form and add it below our tweet preview on the "edit-tweet" view.  We'll change some values so our form submits to our update route.

```ejs
<!-- views/edit-tweet.ejs -->
<main>
  <%- include('_tweet', { tweet: tweet }); %>
  <form id="tweet-form" action="/tweets/<%= tweet.id %>/update" method="POST">
    <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane" value="<%= tweet.handle %>">
    <textarea id="tweet-form-body" name="body" placeholder="What's happening?"><%= tweet.body %></textarea>
    <button id="tweet-form-button">Update Tweet</button>
  </form>
</main>
```

The first thing we change is the form "action" attribute.  Our update route is going to listen for a POST route at "/tweets/:id/update".  We're following the same resource-action pattern.

Next, we are populating inputs with the tweet's current values.  For "input" elements, we give populate it with the "value" attribute.  For "textarea" elements, we put the value in the elements contents.  Lastly, we updated the button to say "Update Tweet" so it's obvious what the user is doing.

Refresh the edit tweet page and you should see the form populated with the tweet values.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/5/5-3-adding-form-to-edit-tweet-page.png)

This is looking really good.  If you try submitting the form, nothing happens yet because we haven't defined our update tweet route.  In the next lesson, we'll be creating our update tweet POST route and updating the tweet in the database.
