---
layout: default
permalink: /courses/twitter-clone/6/1
title: 6.1 Adding A Delete Button
course: Twitter Clone
section: 'Day 6: Deleting A Tweets'
next-lesson-link: /courses/twitter-clone/6/2
---

####Table Of Contents

- **6.1 Adding A Delete Button**
- [6.2 Removing The Tweet From The Database](/courses/twitter-clone/6/2)

Welcome to day 6 of the Twitter clone course.  Yesterday, we created a tweet edit page that let us update tweets.  Today, we are going to cover the "D" (Delete) in CRUD and learn how to delete tweets. Today's lesson is shorter than the previous days because there isn't much to deleting data.  Let's get started.

Like editing tweets, right now, anyone that visits our site will be able to delete tweets.  Don't worry about this too much since tomorrow we will go over how to use cookies to allow only the computer that created the tweet to update or delete it.

From the user's perspective, the only thing we really need to add to our page is a delete button for each tweet.  We could add this button to each tweet on our homepage like we did with the "Edit" link, but putting it there makes it pretty easy to accidently delete a tweet.  Instead, let's put our delete button on the edit tweet page so it's a little harder to accidently delete a tweet.

We could make another POST route to delete tweets and have a new form that submits to that route, but a new form is probably overkill since a delete tweet form would only contain a button.  Instead, we can add our delete button to our update form.

When submitting a form, if you give the button that is submitting the form a "name" attribute, you can check whether the button was clicked.  So for our form, we'll have an "Update Tweet" and a "Delete Tweet" button.  Both will submit the update form and we can check which of these buttons was pressed in the "/tweets/:id/update" POST route. Based on which was pressed, we can either update or delete the tweet.  Let's add a delete button to our form with a name attribute.

```ejs
<!-- views/edit-tweet.ejs -->
<form id="tweet-form" action="/tweets/<%= tweet.id %>/update" method="POST">
  <input id="tweet-form-handle" type="text" name="handle" placeholder="DonkkaShane" value="<%= tweet.handle %>">
  <textarea id="tweet-form-body" name="body" placeholder="What's happening?"><%= tweet.body %></textarea>
  <button id="tweet-form-button">Update Tweet</button>
  <button id="tweet-form-delete-button" name="delete_button">Delete Tweet</button>
</form>
```

We are giving our "Delete Tweet" button a name attribute of "delete_button".  We also gave it an id of "tweet-form-delete-button" so we can style it a little differently than our "Update Tweet" button.

Since we want users to use caution when pressing the delete button, we'll give ours the color red.  Red contrasts with the rest of the site and will make the user more cautious when pressing it.  The following is the style we are going to use for our button.  Add this to site.css.

```css
/* public/css/site.css */
#tweet-form-delete-button {
  color: #ffffff;
  font-size: 14px;
  padding: 7px 8px;
  background-color: #e53334;
  border: 1px solid transparent;
  border-radius: 4px;
  cursor: pointer;
}
```

If you refresh our edit tweet page, you should see the following.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/6/6-1-adding-delete-button.png)

Now we have a delete button that will submit our form, but we don't want users to accidentally click the delete button when they intend to update the tweet.  To prevent this, we can add a confirm dialog that asks the user if they are sure they want to delete.  Update our delete button to look like the following and I'll explain in a minute.

```ejs
<!-- views/edit-tweet.ejs -->
<button id="tweet-form-delete-button" name="delete_button" onclick="return confirm('Are you sure you want to delete the tweet?')">Delete Tweet</button>
```

This line is a little long, but you'll notice I added an "onclick" attribute to the button element. The "onclick" attribute allows us to define some javascript that will be called when the button is clicked.  If true is returned in "onclick" then the button submits.  If false is returned, the button does nothing.

In the "onclick" javascript, we are returning the value returned by the "confirm" function.  This is a javascript function that takes a message and displays it to the user asking if it's okay or not.  If the user presses "OK" then true is returned.  If the user presses "Cancel", false is returned.  This behavior works perfectly for the "onclick" attribute, so we can just return the value from "confirm()".

Now if you refresh the edit page and press delete, you will be asked if you want to delete a tweet.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/6/6-1-adding-confirm-dialog.png)

Pressing "OK" will submit the form and pressing "Cancel" will not.

We now have our delete button created, but submitting the form with our delete button will still update the tweet rather than delete it since we haven't update our update route yet.  In the next section, we'll add a check for which button was pressed and update or delete the tweet accordingly.
