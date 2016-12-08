---
layout: default
permalink: /courses/twitter-clone/2/3
title: 2.3 Adding The Tweet Form
course: Twitter Clone
section: 'Day 2: Creating The Tweets Form In HTML/CSS'
---

Next, let's make a form so users can submit tweets.  Since creating user profiles is out of the scope of the course, we are going to have the user input their Twitter handle as well as the body of their tweet.  Let's replace the contents of our “main” element with our tweet form.

```html
<main>
  <form id="tweet-form" action="/tweets/create" method="POST">
    <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane">
    <textarea id="tweet-form-body" name="body" placeholder="What's happening?"></textarea>
  </form>
</main>
```

HTML has a “form” tag that we use to define forms and anything inside is part of the form.  On our “form” element, we have attributes defining the forms behavior.  We know what “id” does so we'll skip that.  The “action” attribute is the path our form will submit to and the “method” attribute is the HTTP method we want to use.  Since our form will be creating tweets, we are going to use the POST method.  I'll explain this more in later sections.

Browser forms are only capable of making GET and POST requests so those are the only valid values for “method”.

Inside the “form” element we have elements that take user input.  The first one is an “input” element.  Once again we are defining an id that describes what our element is.  Next, we define the input “type”.  Since we are asking for the user's twitter handle, we set it to “text”.

The next attribute is giving the element a “name”.  This is used by the server to get the values of each input when the form is submitted.  There shouldn't be two elements with the same name in the same form.

The last attribute is the “placeholder” attribute and it defines what hint text should be shown when the input doesn't have any text.

Next, we have a “textarea” element which is similar to our text input above, but is designed to be multi lined and contain more text.  First we give it an id and then we define a “name” for the input.  Lastly, we are giving it the “placeholder” text of “What's happening?”.  Save this and reload the page.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/add-tweet-form-input-values.png)

Right now, our form isn't very nice to look at.  Let's add some style.  We'll start with the “form” element:

```css
#tweet-form {
  padding: 10px 12px 10px 12px;
  background-color: #e8f4fb;
}
```

The first line is giving our form some “padding”.  Padding is similar to margin in that it adds extra space around the element, but padding is inside the element's border rather than outside.  You can read more about padding here.  Lastly, we are giving our form a background color.

Next, let's add some style to our inputs now.

```css
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
```

We have already gone over the properties used above, so we aren't going to go into detail about what they do.  Reload the page and our tweet form should look like this:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/style-tweet-form.png)

Our tweet form is almost done, but it needs a button so the user can submit the form.  To do this, we are going to use the “button” element.  Let's add this to the end of our form:

```html
<form id="tweet-form" action="/tweets/create" method="POST">
  <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane">
  <textarea id="tweet-form-body" name="body" placeholder="What's happening?"></textarea>
  <button id="tweet-form-button">Tweet</button>
</form>
```

We are giving our button the id “tweet-form-button” and the text “Tweet”.  If you reload the page, you'll see our button, but it looks like something that belongs on a 90s web page.  Let's change that.

```css
#tweet-form-button {
  color: #ffffff;
  font-size: 14px;
  padding: 7px 8px;
  background-color: #1b95e0;
  border: 1px solid transparent;
  border-radius: 4px;
  cursor: pointer;
}
```

We've seen all of these properties used except the “cursor” property.  This property defines what the mouse cursor should look like when over the element.  Since we want to click on the “button” element, we give it a pointer cursor to tell the user they should click.  Reload the page and you should see a nice blue tweet button.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/add-tweet-form-button.png)

That concludes day 2 of the Twitter clone course.  Our page is starting to look pretty good.  It's not complete yet, but we now have a page that has a form for us to create Tweets.  On day 3, we'll connect this form to our server and save Tweets to our database.  Stay tuned, because this is where web development gets really exciting.  You will really start to see your web app start coming together. Thanks for following along, and I'll see you in the next lesson.
