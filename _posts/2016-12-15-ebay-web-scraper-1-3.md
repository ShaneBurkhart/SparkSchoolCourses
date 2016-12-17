---
layout: default
permalink: /courses/ebay-web-scraper/1/3
title: 1.3 Your First Ruby Program
course: eBay Web Scraper
section: 'eBay Web Scraper Course'
next-lesson-link: /courses/ebay-web-scraper/1/4
---

####Table Of Contents

- [1.1 Introduction](/courses/ebay-web-scraper/1/1)
- [1.2 Installing Tools](/courses/ebay-web-scraper/1/2)
- **1.3 Your First Ruby Program**
- [1.4 Scraping An eBay Product Page](/courses/ebay-web-scraper/1/4)

When building any project, it's always a good idea to start with a simple program to make sure you have everything installed and set up correctly.  Most people call this program the "Hello world!" program since the goal is to print "Hello world!" to the terminal.  If you can do this, then you know everything is set up correctly and you can start building your project.

Before we do anything we need a directory for our project.  I put my project directories on the Desktop so we are going to do the same in this course.  Create a directory (folder) on your Desktop and call it "eBayScraper".  

Now open your text editor (Sublime Text 3) and select File > New File.  Go to File > Save As and save our new file in our "eBayScraper" directory.  Name this file "scraper.rb" and press save.

We are using the ".rb" file extension since our file is a Ruby file.  The "scraper.rb" file will hold our web scraper code.  Right now though, we are going to have it print "Hello world!" to our terminal.  Add the following line to "scraper.rb".

```ruby
# scraper.rb
puts("Hello world!")
```

The "puts" function is a Ruby function that prints text to the terminal.  This is equivalent to calling "console.log()" in Javascript.

Just like Javascript, in Ruby, we call functions with parenthesis and pass arguments separated by commas in those parenthesis.  Having said that, in Ruby the parenthesis are optional.  For this course, we are going to use them so it's easier to understand what the code is doing.  When looking at other people's code though, it's important to know parenthesis are optional.  The above code could also be written like the following.

```ruby
# Ruby Example
puts "Hello world!"
```

Notice how in both code snippets above, we didn't add a semicolon to the end of each line of code.  In Ruby, we don't need to add semicolons at the end of each line.

Save this program and let's run it.  The first thing we need to do is open our terminal (PowerShell on Windows) and navigate to our project directory.  Type the following command into your terminal and press enter to execute it.

```bash
# Terminal
cd ~/Desktop/eBayScraper
```

Now that we are in our project directory, we can run the "scraper.rb" file with the "ruby" command.  Let's do that now.

```bash
# Terminal
ruby scraper.rb
```

To run Ruby files, you type "ruby" followed by the name of the file we want to run.  In our case, it's "scraper.rb".

If everything worked out correctly, you should see "Hello world!" printed to your terminal.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/ruby-hello-world.png)

Now that we know everything is working properly, we can start building our web scraper.

