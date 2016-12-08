---
layout: default
permalink: /courses/twitter-clone/5/1
title: 5.1 Adding An Edit Link To Tweets
course: Twitter Clone
section: 'Day 5: Editing Tweets'
next-lesson-link: /twitter-clone/5/2
---

####Table Of Contents

- **5.1 Adding An Edit Link To Tweets**
- [5.2 Getting Our Tweet From The Database](/courses/twitter-clone/5/2)
- [5.3 Creating An Edit Tweet Page](/courses/twitter-clone/5/3)
- [5.4 Updating The Tweet In The Database](/courses/twitter-clone/5/4)

Welcome to day 5 of the Twitter clone course.  Yesterday, we read our tweets from our database and rendered them to our homepage.  Today, we are going to cover the “U” (Update) in CRUD and learn how to edit those tweets after we have created them. Let's get started.

After today, anyone that visits the site will be able to edit tweets.  This isn't ideal, but as I've mentioned earlier, creating users is out of the scope of the course.  Don't worry though, on day 7, I'm going to go over how we can restrict editing tweets to the computer that created them.

Let's talk a little about what we need to edit a tweet.  The first thing we need is a link on each tweet that takes us to a page to edit the tweet.  On that same note, we need a GET route that serves a page with a form to update the selected tweet.  This route will get the tweet from the database, render the form template and populate the form with the existing tweet data.  Much like we did when creating tweets, we need another route that the form submits to.  In this route though, we will be updating the existing tweet rather than creating a new tweet.

Let's start at the beginning.  We need a link to take us to an edit tweet page.  In a previous lesson, I mentioned that it's a good idea to define routes with the resource we are working on, followed by the action we are doing.  We are still going to follow that rule, but we'll have to elaborate a bit since the path “/tweets/edit” has no way of determining which tweet to edit.

We have an “id” column for our tweets that uniquely identifies them.  We can put the tweet id in the URL to tell our server which tweet we want to edit.  Our resource we are working on is now a specific tweet and a standard way to define this is “/tweets/:id” where “:id” is the tweet id.  Our final path comes out to “/tweets/:id/edit”.  So “/tweets/1/edit” would render a page to edit the tweet with the id of 1.

Let's define a GET route for our “/tweets/:id/edit” path.  I'm going to add this under our create tweet route.

```javascript
app.get('/tweets/:id/edit', function(req, res) {
});
```

You may be wondering what the “:id” portion does in our path.  In Express, we can define parameters in URL paths with a colon followed by the name of the parameter.  Forward slashes mark the beginning and end of the parameter.  Express will then extract the portion we define as a parameter and provide it to us on the request parameter passed to our route function.

Our “req” parameter has a “params” object that holds the parameters for the request.  Let's print the “id” parameter on our edit page so we can play around with it to see how it works.

```javascript
app.get('/tweets/:id/edit', function(req, res) {
  res.send(req.params.id);
});
```

Restart your server and visit http://127.0.0.1:8080/tweets/1/edit and you'll see a “1” on the screen.  This is really close to what we want but what happens when you put text in the “id” parameter instead of a number?

Visit http://127.0.0.1:8080/tweets/some-text/edit and you should see “some-text” on our page.  We don't want to allow text in our “id” parameter since our ids are numbers only.  Luckily, Express has a way we can restrict our parameter to only numbers.  I'll add that now and explain after.

```javascript
app.get('/tweets/:id([0-9]+)/edit', function(req, res) {
  res.send(req.params.id);
});
```

The only thing we added was the “([0-9]+)” after our “id” param.  Express allows us to add an optional parenthesis at the end of the param name that contains a pattern to match.  The pattern uses regular expressions which is simply a way to match patterns in text.  Regular expressions are out of the scope of the course, but what you need to know is that the “[0-9]” part says “any number 0-9” and the “+” after says “one or more” number.

Restart your server and visit http://127.0.0.1:8080/tweets/some-text/edit again.  You should see a screen like the following that indicates the URL isn't valid.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/5/5-1-edit-text.png)

Now our edit tweets path's id parameter can only contain numbers.  Let's add a link to our tweet that takes us to the edit page.

```html
<% for(var i = 0; i < tweets.length; i++) { %>
  <% var tweet = tweets[i]; %>
  <article class="tweet">
    <p>
      <a href="http://twitter.com/<%= tweet.handle %>">@<%= tweet.handle %></a>
      <span class="light-grey"> - <%= tweet.time_from_now %></span>
    </p>
    <p><%= tweet.body %></p>
    <p><a href="/tweets/<%= tweet.id %>/edit">Edit</a></p>
  </article>
<% } %>
```

We simply added an anchor tag to each tweet with the text “Edit” and the href of “/tweets/:id/edit”.  I put this in a “p” tag so it would be on it's own line at the bottom of the tweet.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/5/5-1-edit-links-on-tweets.png)

You can now click the “Edit” link to visit that tweet's edit page.  Right now the page only prints the “id” parameter.  In the next lesson, we'll be getting the tweet from the database so we can render and edit it later.
