---
layout: default
permalink: /courses/twitter-clone/4/1
title: 4.1 Creating A Tweet In HTML/CSS
course: Twitter Clone
section: 'Day 4: Showing Tweets'
next-lesson-link: /courses/twitter-clone/4/2
---

####Table Of Contents

- **4.1 Creating A Tweet In HTML/CSS**
- [4.2 Reading The Tweet From The Database](/courses/twitter-clone/4/2)
- [4.3 Rendering Tweets On Our Page](/courses/twitter-clone/4/3)

***Make sure you are logged into Vagrant before starting today's lessons.*** <a href="/guides/logging-into-vagrant" target="_blank">Click here to view the "Logging Into Vagrant Guide"</a>

Welcome to day 4 of the Twitter clone course.  Yesterday, we connected our tweet form to our server and saved the tweet to our database.  Today, we are going to get those tweets and render them on our homepage. After today, your site will feel very interactive because you can create tweets and see them appear on our feed.

Since we've already gone over HTML and CSS basics, I'll show you how I would go about designing a tweet in this lesson.  We'll be walking through some of the steps and iterations we take to design the tweet.  Even though I'm going to show you more of the process, there was still a lot of trial and error involved in getting the styles I wanted.  I tell you this so you don't get impatient when creating your own HTML and CSS.  It takes time to get things looking good.  Let's get started.

Before we can render our Tweets on the page, we need to make static version of a Tweet.  I like to start with a static version so I can focus on designing what I want the tweet to look like before I try to populate it with data from our database.

Open "tweets.ejs" and let's start making a tweet.  In HTML, there is an element tag called "article" that is used to contain HTML that would make sense on it's own.  An example of this would be the contents of a blog post because a blog post should make sense on it's own.  Tweets are the same way in that reading a single tweet should still make sense.  Let's add an "article" element under our tweet form and give it the class "tweet" so we can style our tweet.

```ejs
<!-- views/tweets.ejs -->
<body>
  <header></header>
  <main>
    <form id="tweet-form" action="/tweets/create" method="POST">
      <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane">
      <textarea id="tweet-form-body" name="body" placeholder="What's happening?"></textarea>
      <button id="tweet-form-button">Tweet</button>
    </form>
    <article class="tweet">
    </article>
  </main>
</body>
```

We now have a container for our tweet, let's add some info about our tweet.  Let's think about what we want to show.  A tweet has a user handle, and a text body so we'll for sure want to render that.  It's also useful for users to know when the tweet was posted so we also need some text that tells us how long ago the tweet was created.

First things first, let's add our user handle and tweet body to our tweet element.

```ejs
<!-- views/tweets.ejs -->
<article class="tweet">
  <p>@DonkkaShane</p>
  <p>I'm having a great time teaching the Twitter clone course!</p>
</article>
```

With our web server running, if you load [http://127.0.0.1:8080](http://127.0.0.1:8080), you should see a pretty ugly tweet with our tweet body and handle.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/initial-tweet.png)

Let's add a little bit of style. The first thing we need to do is line up our text with our form inputs.  We do that by putting some padding on our article element.  It also wouldn't be a bad idea to add a subtle border between the tweet form and the tweet.  Right now, the blue from the form runs into the white in our tweet, but they are separate entities, so we want to make a clear distinction between them.  Add the style below to "site.css".

```css
/* public/css/site.css */
.tweet {
  padding: 10px 12px;
  border-top: 1px solid #e1e8ed;
}
```

Reload the page and it should look like the following:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/adding-padding-to-tweet.png)

Our tweet is starting to look a little better.  We also want to display how long ago the tweet was created.  Let's add that after our Twitter handle and separate it with a dash ("-").

```ejs
<!-- views/tweets.ejs -->
<article class="tweet">
  <p>@DonkkaShane - 18 minutes ago</p>
  <p>I'm having a great time teaching the Twitter clone course!</p>
</article>
```

We just added the time since creation to the end of our first paragraph element's contents.

Now, let's make the handle a link to the Twitter user profile page for the handle.  We do that with an "a" HTML tag.  This stands for anchor and is a text link in HTML.  Anchor tags require only an "href" attribute that tells the browser where to go when clicking the link.  Anything inside an anchor element is the link's text.  We want that to be our Twitter handle so we'll wrap our handle in an anchor element. Let's turn our handle into a link.

```ejs
<!-- views/tweets.ejs -->
<article class="tweet">
  <p><a href="http://twitter.com/DonkkaShane">@DonkkaShane</a> - 18 minutes ago</p>
  <p>I'm having a great time teaching the Twitter clone course!</p>
</article>
```

Notice we gave our link the "href" of "http://twitter.com/DonkkaShane".  To access a user profile by handle on twitter, we follow the URL pattern of "http://twitter.com/<handle>" where we replace the "<handle>" portion with the user's handle.  Reload the page and it should look like the following.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/tweet-handle-to-link.png)

If you click on the link, you will be redirected to my Twitter profile page.

We're pretty close, but I think the our tweet's time since created stands out a little too much.  Time since created is more of a fine print kind of thing and is less important to the tweet so we want to emphasize it less so we don't detract from the tweet body and handle.  Let's color the time since created text a light grey.

To add style to a section of text, we use the "span" HTML element.  Wrap "- 18 minutes ago" in a "span" element and give it the class name of "light-grey".  We are creating a generic light grey class so we can quickly apply it to other elements as well.  We won't use this class again in this course, but it's always a good idea to write style and code that is reusable to avoid duplicate code.  Let's wrap the time since created now.

```ejs
<!-- views/tweets.ejs -->
<article class="tweet">
  <p><a href="http://twitter.com/DonkkaShane">@DonkkaShane</a><span class="light-grey"> - 18 minutes ago</span></p>
  <p>I'm having a great time teaching the Twitter clone course!</p>
</article>
```

Let's also define our "light-grey" class style.

```css
/* public/css/site.css */
.light-grey {
  color: #8899a6;
}
```

Now if you refresh the page, the time since created text should be a light grey.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/4/time-from-text-to-light-grey.png)

We are going to leave our tweet style simple like above.  User profiles and uploading images is out of the scope of this course, so we aren't going to add a profile image.  This course is about understanding the basics of a web app, so we are going to stick to understanding CRUD apps.

Now we have a static tweet, but we want to populate this with tweets from our database.  In the next section, we will be getting our tweets from our database so we can render them to the page.

### Final Code

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
      <article class="tweet">
        <p><a href="http://twitter.com/DonkkaShane">@DonkkaShane</a><span class="light-grey"> - 18 minutes ago</span></p>
        <p>I'm having a great time teaching the Twitter clone course!</p>
      </article>
    </main>
  </body>
</html>
```

```css
/* public/css/site.css */
header {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  background-color: #ffffff;
  border-bottom: 1px solid #d9d9d9;
  height: 50px;
}

main {
  width: 600px;
  margin: 60px auto 0px auto;
  background-color: #ffffff;
  border: 1px solid #e1e8ed;
  border-radius: 6px;
}

body {
  background-color: #f5f8fa;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 14px;
  box-sizing: border-box;
}

*, *:before, *:after {
  box-sizing: inherit;
}

#tweet-form {
  padding: 10px 12px 10px 12px;
  background-color: #e8f4fb;
}

#tweet-form-handle {
  font-size: 14px;
  margin-bottom: 8px;
  padding: 8px 10px 8px 10px;
  border: 1px solid #a3d4f2;
  border-radius: 3px;
  width: 100%;
}

#tweet-form-body {
  font-size: 14px;
  margin-bottom: 8px;
  padding: 8px 10px 8px 10px;
  border: 1px solid #a3d4f2;
  border-radius: 3px;
  width: 100%;
}

#tweet-form-button {
  color: #ffffff;
  font-size: 14px;
  padding: 7px 8px;
  background-color: #1b95e0;
  border: 1px solid transparent;
  border-radius: 4px;
  cursor: pointer;
}

.tweet {
  padding: 10px 12px;
  border-top: 1px solid #e1e8ed;
}

.light-grey {
  color: #8899a6;
}
```
