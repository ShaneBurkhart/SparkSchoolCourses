---
layout: default
permalink: /courses/twitter-clone/2/2
title: 2.2 Adding Style To Our HTML Page With CSS
course: Twitter Clone
section: 'Day 2: Creating The Tweets Form In HTML/CSS'
next-lesson-link: /courses/twitter-clone/2/3
---

####Table Of Contents

- [2.1 Creating A Simple HTML Page](/courses/twitter-clone/2/1)
- **2.2 Adding Style To Our HTML Page With CSS**
- [2.3 Adding The Tweet Form](/courses/twitter-clone/2/3)

You've now created your first HTML page, but let's start writing our Tweets feed page.  Because this is a Twitter clone, we are going to mimic Twitter's site style as much as possible.  For today, we are just going to create the Tweet form.  We'll work on rendering Tweets after we have the ability to create them.

Like most website these days, we need a header bar.  Header bars have become a web standard for displaying high level site navigation.  Header bars usually contain links to about pages, blog articles, user profiles, etc.  We don't have any other pages yet so our header won't contain any links just yet.

In HTML5 there is an element type called "header" that is used to define a site's header.  Above our "h1" element add a header element:

```ejs
<!-- views/tweets.ejs -->
<header></header>
<h1>Twitter Clone Course</h1>
<p>We're learning HTML!</p>
```

If you reload this in your browser, nothing should really change since our header doesn't have any contents and we haven't given it any style yet.

Earlier, I mentioned that you have to stop and restart your server every time you update Javascript code.  Because Express reloads the EJS file on each request, there is no need to restart your server when you are updating EJS files.  Express will reload EJS files for us automatically.

Let's give our header some style now.

###CSS 101

HTML is used to structure a web page, but overall, HTML is fairly plain.  To add style to HTML, we use CSS which stands for cascading style sheets.

CSS is a simple language, that defines styles for a given set of elements.  CSS defines which elements to set style on with CSS selectors.  Let's go over those now.

Earlier I mentioned that HTML element attributes are used to add identification to elements.  CSS uses these identification attributes in selectors to determine which elements should receive which style. There are three different ways to identify HTML element:

**Tag name** - Tag names are the element types we discussed earlier.  Since most tags can exist more than once on the page, when identifying elements by tag name, you will get all elements with that tag name.

**Class** - Class names are custom names we give elements and more than one element can have the same class name.  These are useful when you want to apply a style to more than one element but the elements don't have the same tag name.

**Id** - Ids are names we give elements that uniquely identify them on the page.  This means there shouldn't be more than one element with the same id on the page.

An HTML element can have any combination of the above identifiers.  All elements always have a tag name, but can also have multiple class names and an id.

The following snippet of code contains the three main selectors:

```css
/* CSS Example */
header
.tweet
#site-logo
```

The first line is a tag name selector that will get all of the elements on the page with the "header" tag name.  The second line is a class name selector that gets all of the elements on the page with the class "tweet".  The third line is an id selector that grabs the element with the "site-logo" id.  Notice that id selectors are prefixed with a "#", class name selectors are prefixed with a "." and tag name selectors aren't prefixed with anything.

With knowledge of selectors, we can now style our header.  The first thing we need to do is create a CSS file and load it on our HTML page.  In the root of our project, create a directory called "public".  We call it "public" because the files in this directory will be publicly accessible to the browser.  Another common name is "static".

This is going to contain all of our css files and images.  To stay organized, create a "css" directory in the "public" directory.  Now that we have a directory for our css files, we can create a "site.css" file in the "css" directory.  Do that now in Sublime Text.

Right now, our CSS file can't be accessed since we haven't told Express where it can find our public files. This is an issue because our HTML page is going to import this file for style. You can test that you can't see the file by visiting [http://127.0.0.1:8080/css/site.css](http://127.0.0.1:8080/css/site.css).

CSS files are what we call static files.  This means that they aren't dynamically created and our web server can immediately send the file to the browser rather than going through a route like our homepage.  This saves time because our server has to do less work.

To tell Express to send static files, we need to add some middleware.  We'll get more into middleware later, but for now, middleware is code that will run before and after a request gets sent to a route.  Middleware helps use eliminate duplicate code since most routes need some kind of similar functionality.

Express provides middleware we can use to server static files.  To add middleware, we use the "use" method on the "app" variable.  This takes the middleware we are going to use as an argument.  Let's add this under our view settings code.

```javascript
// app.js
app.set('view engine', 'ejs');
app.set('views', './views');

app.use(express.static('public'));
```

As you can see, we are using the Express static middleware.  Calling the "static" function on our "express" variable returns static middleware.  The argument it takes is directory containing our static files.  In our case, this is the "./public" directory.  After adding that line, restart you server for the changes to take effect.

Now anything in our "public" directory can be accessed by the browser.  You can view our "site.css" file by going to [http://127.0.0.1:8080/css/site.css](http://127.0.0.1:8080/css/site.css)

We now have a CSS file and it's publicly accessible, but we aren't loading it on our page.  To load CSS files in HTML, we put a "link" element in the "head" element of our page.  Let's do that now:

```ejs
<!-- views/tweets.ejs -->
<link rel="stylesheet" type="text/css" href="/css/site.css">
```

The "link" element is a little different than the elements we have previously discussed because it doesn't have a closing tag.  Some elements don't have closing tags since it doesn't make sense for them to have contents.

Let's look at the attributes on the element.  The "rel" attribute is telling the browser we are loading a stylesheet.  The "type" attribute is defining the type of file it is and finally the "href" is the path to our CSS.

Let's test to make sure the file is loaded properly by turning the background color of the page to blue.  To do this, open your "site.css" file and type the following.  Save and reload the page.

```css
/* public/css/site.css */
body {
  background-color: blue;
}
```

Let's break down what the above is doing.  To define a CSS style, you type the selector you want followed by curly braces.  Inside the curly braces, you define the style for the elements that the selector applies to.

To set a property for the style, you type the name of the property followed by a colon and then the value you want to set it to.  Like in Javascript, each style property needs to end in a semicolon.

Our selector above is looking for the body element and setting the "background-color" property to "blue". Reload the page and you should see your web page turn blue.

I mentioned earlier that CSS is largely a lot of tweaking until you get it to look the way you want it to.  Sometimes we want to see what style an element has in the browser.  Chrome has developer tools we can use to see the style of elements.  In our chrome browser, find the element you want to inspect and right click it and press "Inspect".

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/chrome-developer-tools.png)

This brings up chrome developer console (yours might be white) and selects the element we right clicked on.  On the right hand side of the console, you can see the style of the element we have selected.  Click on different elements on the left to change which element you have selected.  When hovering an element, you should see it highlight on the page.

This is a really useful tool to see how other people are styling their page and it makes it easier to see exactly what your style is doing.  You won't need to use this much now, but it's good that you know it exists so you can use it in the future.

Let's get back to styling our site header.  In our case, we are going to have only one header element per page so we can use the tag name selector.  Replace the "body" style with the style for our header:

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
```

The first property is the "position" property which defines how the element will be positioned on the page.  We are setting the header position to "fixed" which means it will stay fixed to the browser window when scrolling.

There are a few different position types, but we aren't going to go into detail since there are plenty of guides that do that for us.  If you want more detail, check out this [guide on element positioning](https://css-tricks.com/almanac/properties/p/position/).

Most of CSS is pretty straightforward and can be done with a reference.  It's all about tweaking and constant iteration.  We aren't going to go into details on the specifics of CSS since it's out of the scope of the course.

The next three properties, "top", "left", "right", define how our fixed position element should be placed in the browser window.  The value given is the offset of the side of the element to the same side of the window.  So if the property "left" is set to zero, then the left side of our element will be on the far left side of our browser window. The same applies to the other sides.

The first four properties position the header how we want it and the next three add some style so we can see it easier.

We set "background-color" to "#ffffff" which is hexadecimal for white.  There are a few different color formats that CSS accepts and hexadecimal is one of the more common.  Here is a really good explanation on [how hexadecimal colors work](http://stackoverflow.com/questions/22239803/how-does-hexadecimal-color-work#answer-22239907).

Next we are defining "border-bottom" which as it sounds, defines the border on the bottom side of the element.  This sets a "solid" border of "1px" wide with the color "#d9d9d9".  Last, we define the "height" property and give it a value of "50px". Reload the page and you should see a light gray header:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/page-with-header.png)

It looks like our header is covering up our "h1" tag.  We'll fix this in a bit.

You may or may not have noticed, but modern sites don't normally have their main content going all the way across the page.  This stretches your content out and makes it look unnatural and hard to read.  To fix this, we add spacing on the left and right of our content to get it closer to the center of the screen.  Since we want to do this for the entire page (minus the header), let's use an element to wrap our content and position everything.

In HTML5 there is an element called "main" that contains the main content for the page.  We are going to include everything but the site header since the site header is on every page and isn't really specific to this page.  Below our "header" element, add a "main" element and put our "h1" and "p" tags in it's contents.

```ejs
<!-- views/tweets.ejs -->
<header></header>
<main>
  <h1>Twitter Clone Course</h1>
  <p>We're learning HTML!</p>
</main>
```

If you reload the page, you'll notice nothing happened.  This is because we haven't given it a style yet.  Let's give our "main" element some style:

```css
/* public/css/site.css */
main {
  width: 600px;
  margin: 60px auto 0px auto;
  background-color: #ffffff;
  border: 1px solid #e1e8ed;
  border-radius: 6px;
}
```

The first line defines the "width" and we are setting it to "600px".  Usually your main content is somewhere in the 600-1000px range depending on how much content you have.  Since tweets are small, we are staying on the small side.

The next line defines the margins (spacing), for the element.  Each value corresponds to a side of the element.  The order is top, right, bottom, then left.  Our header was covering some of our content, so we are giving our main content a "60px" top margin to push it under our header.  For the sides, we are giving the margin or "auto" which will center the element in it's container if the container has a width.  We defined a width earlier so this will center our element on the page. The bottom side margin is set to "0px".

We talked about "background-color" and "border" earlier, but this time, we are defining the border on all sides.

The last property is "border-radius" which gives our element rounded corners based on the radius we give "border-radius".  For our element, we are giving it "6px".  Reload the page and you should see your content in the middle of the screen:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/created-main-content-container.png)

Our page is starting to look like an actual web page.  It's a little plain, so let's add a subtle background color and change the font to something less formal.  To do this, let's add some style to the "body" element.

```css
/* public/css/site.css */
body {
  background-color: #f5f8fa;
  font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
  font-size: 14px;
  box-sizing: border-box;
}
```

The first line is straightforward and is changing the background color.  The next line is setting the "font-family" property and we give it font names separated by commas.  We give it more than one font because not all fonts are on all computers so the browser needs to know what to fall back on if it can't find one.  It'll first look for "Helvetica Neue", then "Helvetica", then "Arial", etc.

Like most things, font families aren't something you need to memorize.  There are sites that help you define them.  [CSS Font Stack](http://www.cssfontstack.com/) is an awesome site that shows you different font families and their browser compatibility. I used this for the font family above.

The next line is setting the "font-size" to "14px".  The last line is setting the "box-sizing" property to "border-box".  This property defines how elements are measured and is out of the scope of the course.  If you want to know more, [CSS Tricks](https://css-tricks.com/) has a great [guide on box sizing](https://css-tricks.com/box-sizing/).

"Font-family" and "font-size" are inherited properties meaning the element's children will also have the same properties unless specifically set differently on the child element. Reload this and you should see the font and the background color of the page change.

Unfortunately, the "box-sizing" attribute isn't inherited but we want it to be.  We can change that by adding the following style.  This is a little out of the scope of the course, so don't worry about the details of what this is doing.  Instead, just know that we use this so all of our elements can have the same "box-sizing" property.

```css
/* public/css/site.css */
*, *:before, *:after {
  box-sizing: inherit;
}
```

Add that to your "site.css" file, save and reload the page.  You should see the following.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/add-background-color.png)

You now know the basics of styling an HTML page.  In the next lesson, we are going to create a Tweet form that users will use to submit Tweets.

### Final Code

```javascript
// app.js
'use strict'

var express = require('express');
var app = express();

app.set('views', './views');
app.set('view engine', 'ejs');

app.use(express.static('public'));

app.get('/', function(req, res) {
  res.render('tweets');
});

app.listen(8080, function() {
  console.log('Web server listening on port 8080!');
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
      <h1>Twitter Clone Course</h1>
      <p>We're learning HTML!</p>
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
```
