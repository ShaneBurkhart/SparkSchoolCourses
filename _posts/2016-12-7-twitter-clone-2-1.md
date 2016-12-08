---
layout: default
permalink: /courses/twitter-clone/2/1
title: 2.1 Creating A Simple HTML Page
course: Twitter Clone
section: 'Day 2: Creating The Tweets Form In HTML/CSS'
next-lesson-link: /twitter-clone/2/2
---

Welcome to day 2 of the Twitter clone course.  Today we are going to making our first web page.  This is going to be the page we display tweets on as well as have a form that allows people to submit tweets.  Today though, we are going to focus on building the form so we can create Tweets on day 3.

Writing web pages in HTML and CSS usually takes a lot of iterations.  There is a lot of trial and error to get everything to look the way you want it.  This is mostly design work which is more time consuming than technically challenging, so it's not something we are going to cover in detail.

If you're interested in learning more about design, I recommend looking at other people's work and see if you can't replicate their design.  https://dribbble.com/ is an awesome place to get inspired by great design.

Remember that all terminal commands we run today refer to running them in our VM.  Make sure you are logged in to your VM before getting started.  If you need help, refer back to the “Setup Your Project And Connect To Your VM” in day 1.

###HTML 101

HTML isn't complicated and it's more of a format than it is a language.  What I mean by this is HTML doesn't contain any logic and instead is just a document that tells the browser how the web page should be structured.

To learn HTML, you just need to know the basic syntax and then use a reference for the specific element types.  To this day, I don't remember all of the element types and it's not realistic for anyone to do that.  It's not uncommon for me to look up something for reference.

Let's go over HTML syntax.  Below is a diagram explaining HTML syntax.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/HTML-element-markup-syntax-diagram.png)

HTML is made up of elements and each element has a closing and opening tag.  Opening tags start with “<” and end with “>” while closing tags start with “</” and end with “>”.  Anything between the opening and closing tag is the contents of the element and the contents can be other elements.  In this case, the contents is the text “Hello World”.

Here is a pretty good reference for HTML elements.  It does a good job of splitting elements up by purpose so it's a little easier for you to find what you are looking for.

The first thing that goes inside the opening and closing tags is the element tag name.  In the above example, our HTML element has a tag name of “h1” which stands for header 1.  This is the biggest header on the page and usually is the primary heading for the page.  H1 tags are unique on a page meaning there should only ever be one h1 tag on a given page.

The closing tag is pretty simple and only ever contains the element tag name that we are ending.  The opening tag on the other hand can contain attributes which are used to specify how elements should behave.  In the above example, we are setting the “class” attribute to the value “primary”.

Now that we understand basic HTML syntax, let's create our first page.  It's generally a good idea to keep all of you HTML in a separate directory so we stay organized.  HTML files are commonly referred to as views.  This makes sense because each file is a specific “view” we show the user. Create a folder in our project directory called “views”.  In the “views” folder, create a file called “tweets.ejs”.

You may have noticed that we used the “.ejs” file extension instead of the “.html” file extension.  This is because we are going to be using a template engine called EJS in future lessons.  EJS files can contain HTML, so for now, think of “.ejs” as an HTML file.

Let's write a basic HTML page with a title heading and some text.  Below is the code for the page and I'll explain it in a second:

```html
<!DOCTYPE html>
<html>
    <head>
    </head>
    <body>
        <h1>Twitter Clone Course</h1>
        <p>We're learning HTML!</p>
    </body>
</html>
```

The first line of any HTML document is the doctype and it tells the document what version of HTML we want to use.  The version we have specified is HTML5.  There will probably never be a time where your doctype doesn't look like the one above.

Although the doctype looks similar to an HTML element, it is not one.   The doctype just tells the browser how to interpret the file.

The first element on the page is the “html” element.  This tag wraps the entire page and contains the elements of the page.

Inside the “html” tag are two elements: the “head” element and the “body” element.  The “head” element is invisible and is used to define metadata and include CSS and Javascript files.  We aren't going to use the “head” element right now, so we'll explain it later.  For now, we just need to make sure it's included inside the “html” element and before the “body”.

The next child in the “html” element is the “body” element.  This element contains everything that you see on the page.

Inside the “body” element, we have our  “h1” and a “p” (paragraph) elements.  The “h1” tag will display the contents, “Twitter Clone Course” and the “p” tag will display “We are learning HTML!”.

All HTML files follow the same pattern as above.  They start with a doctype declaration followed by an “html” tag that contains a “head” and “body” element.  From there, it's up to you how the page will be structured.

Now that we have our page, let's have our web server render our new HTML page.  Before we can do that, we need to install the EJS library:

```bash
npm install ejs --save
 ```

With that saved, we can tell Express to use EJS as our templating engine.  We also need to tell Express where it can find our view (HTML) files.  To do this, we need to add these two lines under the “var app = express();” line:

```javascript
app.set('view engine', 'ejs');
app.set('views', './views');
```

Express provides the “set” method on the app variable to set settings.  The first argument is the name of the setting and the second is the value we are setting it to.  Each setting does something different and you can find a list of setting here.

In the example above, the “views” setting defines where our views can be found.  We are setting this to “./views”.  The period at the beginning means the current directory the “app.js” file is in and the “/views” part says we want the “views” directory in the current directory.

The second line sets the “view engine” setting which defines which template engine to use when rendering a view.  We are setting this to “ejs” since we want to use the EJS template engine.

Now that we have told Express how to handle rendering views, let's actually render our EJS file instead of print “Hello World!” text on our homepage.  To do this, we use the “render” method on the “res” variable and pass it the name of our view.  Your homepage route should now look like the following:

```javascript
app.get('/', function(req, res) {
  res.render('tweets');
});
```

Notice how there was no need to add the “.ejs” extension to our view name.  With the settings we set earlier, Express is smart enough to figure out which file you want to render.

Here is the final code so it's easier to see everything:

```javascript
'use strict'

var express = require('express');
var app = express();

app.set('views', './views');
app.set('view engine', 'ejs');

app.get('/', function(req, res) {
  res.render('tweets');
});

app.listen(8080, function() {
  console.log('Web server listening on port 8080!');
});
```

Save this and restart your server by pressing ctrl-c in the terminal and re running the “node app.js” command.

Every time we update our Javascript code, we need to restart our server to see the changes.  There are programs that can auto reload our code for us, but that's out of the scope of this course.

Go to your browser and reload you page.  You should see something like the following:

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/2/simple-html-page-with-header-and-paragraph.png)

Now that we have created a basic HTML page, let's add some style.
