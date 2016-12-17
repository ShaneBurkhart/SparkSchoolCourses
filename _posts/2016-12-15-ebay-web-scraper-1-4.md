---
layout: default
permalink: /courses/ebay-web-scraper/1/4
title: 1.4 Scraping An eBay Product Page
course: eBay Web Scraper
section: 'eBay Web Scraper Course'
---

####Table Of Contents

- [1.1 Introduction](/courses/ebay-web-scraper/1/1)
- [1.2 Installing Tools](/courses/ebay-web-scraper/1/2)
- [1.3 Your First Ruby Program](/courses/ebay-web-scraper/1/3)
- **1.4 Scraping An eBay Product Page**

Now that we have everything set up correctly, let's build our web scraper. The first thing we need to do is find a product listing page we want to scrape.

For this course, our scraper is only going to be capable of scraping auction listings.  Web scraping is inherently unstable due to the fact that you have no control over changes to the site you are scraping.  I want this course to stay relevant so I'm teaching the basics of web scraping rather than building a complete eBay web scraper.  

If you are interested in making your web scraper more complete, at the end of this lesson, I'll talk about what next steps you can take to make it your own.  Let's get started.

The first thing you need when scraping the page is the URL of the page you want to scrape.  Visit [eBay](http://ebay.com) and select an auction listing that has at least a few hours left so the listing doesn't expire before we are done.  For my listing, I searched for "televisions" and then clicked the "Auction" button to get only auction listings.  

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/tv-auction-listings.png)

The listing I use will be expired when you are taking this course.  Remember to swap the URL that I have with the URL of the page you want to scrape.  You can also swap out this URL later to use the same program to scrape a different listing page as well.

Let's save our URL to a variable called "url".  Remove the "puts" call and add the following.

```ruby
# scraper.rb
url = "http://www.ebay.com/itm/LG-49-Inch-4K-Ultra-HD-2160p-120Hz-LED-Smart-TV-49UF6430-/252675043686"
```

In Ruby, to declare variables, you simply type the name of the variable, followed by an equals sign, followed by the value you want to set the variable to.  This looks a lot like defining variables in Javascript, but we don't need the "var" keyword.

In the code above, I'm setting the "url" variable to my auction listing URL.   Simply copy the URL for your listing from the browser and replace my URL with yours.

We have our URL, but we need to get the HTML for the listing from the server.  In our code, we are going to be making a GET request to the listing URL.  The eBay web server will then handle that request and return the HTML for the listing.

To make a simple GET request in Ruby, we include the "open-uri" library and use the "open" function.  Let's do that now.

```ruby
# scraper.rb
require("open-uri")

url = "http://www.ebay.com/itm/LG-49-Inch-4K-Ultra-HD-2160p-120Hz-LED-Smart-TV-49UF6430-/252675043686"
page = open(url)

puts(page)
```

To require libraries in Ruby, we use the "require" function.  We pass the "require" function the name of our library.  In Ruby we call libraries "gems", so I will refer to libraries as gems from now on.

Unlike in Javascript, Ruby's "require" doesn't return the required gem.  Instead, Ruby's "require" returns true or false depending on if the gem loaded successfully.  Don't worry about this now.  It'll become more clear how we use gems in a bit.

When requiring the "open-uri" gem, it creates an "open" function that we can use to send a GET request to a URL.  The "open" function will return an object for our request response.  

In the code above, we are calling the "open" function and assigning its return value to a variable called "page".  The last line is printing the "page" variable to the terminal so we can see what it looks like.  Run your program from the terminal and you should see the following.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-file-object-to-terminal.png)

The output tells us that our "page" variable is a File object.  We want to see the contents of the request response so we need to read the data from the File object.  File objects have a method called "read" that we can call to get the HTML contents of our page.  

Just like in Javascript, we call methods on objects with the dot notation. Let's call the "read" function on our "page" variable and print it to the terminal.

```ruby
# scraper.rb
require("open-uri")

url = "http://www.ebay.com/itm/LG-49-Inch-4K-Ultra-HD-2160p-120Hz-LED-Smart-TV-49UF6430-/252675043686"
page = open(url)

puts(page.read())
```

If you run the program again, you should see the HTML contents of the listings page. 

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/listing-request-response-contents.png)

So we have our response, but it's just a big blob of text right now.  We can't really do anything with it just yet.  To turn our page response into HTML elements, we need to parse the page. 

There is a gem called [Oga](https://github.com/YorickPeterse/oga) that we are going to use to parse our HTML.  Before we can use it though, we need to install it.  In your terminal, make sure you are in your project directory and run the following.

```bash
# Terminal
gem install oga
```

To install gems, we use the "gem" command in the terminal.  The "gem" command is used to manage gems, but we only care about installing gems.  Since we are installing, the next word after our "gem" command is "install" which tells the "gem" command we want to install gems.  Following "install" we put the name of our gems we want to install.  You can specify more than one separated by spaces, but we are only concerned about the "oga" gem. 

Now that the Oga gem is installed, we need to require it in our Ruby file.

```ruby
# scraper.rb
require("open-uri")
require("oga")
```

With the Oga gem required, we can now use it to parse our HTML.  Let's do that and save the parsed HTML to a variable called "doc" (short for document).

```ruby
# scraper.rb
require("open-uri")
require("oga")

url = "http://www.ebay.com/itm/LG-49-Inch-4K-Ultra-HD-2160p-120Hz-LED-Smart-TV-49UF6430-/252675043686"
page = open(url)
doc = Oga.parse_html(page)
```

When requiring the Oga gem, it adds a module called "Oga" that we can use to call Oga methods.  [Ruby modules](https://ruby-doc.org/core-2.2.0/Module.html) aren't exactly like objects, but for the sake of the course, you can think of Ruby modules as objects.

The "Oga" module has a method called "parse\_html" which takes a File object as the first parameter and returns an [Oga Document object](http://code.yorickpeterse.com/oga/latest/Oga/XML/Document.html).  We are going to use this to find elements on our page.  

The Oga Document has a lot of methods for finding elements, but we are going to use the "css" method.  This method allows us to pass CSS selectors to it and returns the elements that match the selector.

Before we can do that, we need to look at the elements we want to scrape on our listings page and see if they have a class or an id.  To do this, we are going to use Google Chrome developer tools.

The easiest way to open Chrome developer tools is to right click on the element we want to scrape and select "Inspect".  This will bring up chrome dev tools and select the element you right click on.

Let's get the bid price first.  Go to your listing in your browser and right click on the bid price.  In the dropdown, select "Inspect".

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/right-click-inspect-bid-price.png)

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/inspecting-bid-price-element.png)

On the left hand side of the developer tools we have the HTML elements for the page.  The highlighted element is the one you right clicked on.  If you hover over different elements, you can see them highlighted on the page above. 

Find the element that contains our bid price text and let's see if it has a class or an id. You might have to use the arrow on the left hand side of elements to see the element's children.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/bid-price-element.png)

It looks like the bid price element has a class of "notranslate" and an "id" of "prcIsum\_bidPrice".  Since ids should be one per page, we are going to use the id.  Let's search our document for elements with the id of "prcIsum\_bidPrice".  Add this to the end of your file.

```ruby
# scraper.rb
bid_price_element = doc.css("#prcIsum_bidPrice").first()
puts(bid_price_element.text())
```

The first line is calling the "css" method on our "doc" variable.  We are passing it our bid element's id prepended with a pound since it is an id selector. The "css" method returns an array which we can call the "first" method on to get the first element in the array. We are getting the first element since only one should be returned.  This element gets set to a variable named "bid\_price\_element".  

Notice how we named our variable differently than we did in Javascript.  This is because each programming language usually has a general coding style for the language.  In Ruby, it's common to name variables with snake casing.  This is all lower case and words are separated by underscores.

The second line is calling the "text" method on our bid price element and printing that value to the screen.  We call the "text" method on our Oga element to get the text of the element.  Run your program and you should see the bid price printed.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-bid-price-to-terminal.png)

Now that we have our bid price, lets save it to a variable called "bid\_price".  Remove the line that is outputting the element text and save the text to a variable instead.

```ruby
# scraper.rb
bid_price_element = doc.css("#prcIsum_bidPrice").first()
bid_price = bid_price_element.text()
```

Now that we have our bid price, let's get our product title.  Right click on the title text in your browser and find the element that has the title text.  

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/inspecting-title-element.png)

It looks like our title text is inside the "h1" element along with some hidden text that says "Details about" followed by some spaces.  We'll get rid of the hidden text in a minute, but for right now, we need to get the title element's id.  It looks like the id is "itemTitle", so let's search our document for elements with that id.

```ruby
# scraper.rb
bid_price_element = doc.css("#prcIsum_bidPrice").first()
bid_price = bid_price_element.text()

title_element = doc.css("#itemTitle").first()
puts(title_element.text())
```

Once again, we are using the "css" method and passing it our id selector.  We then get the first element returned and save that to a variable "title_element".  To see the text of the element, we are going to print it to the terminal.  Run this and you should see the listing title prepended with "Details about".

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-unsanitized-title-text-to-terminal.png)

We don't want the "Details about" portion of the title, so we are going to remove that now.  To do this, we are going to use the "sub" method on the title text.  

The "sub" method is short for substitute and is used to substitute some text for another.  The first argument to "sub" is the text we want to replace and the second argument is the text we are replacing it with. The method then returns the new text with substitutions. In our case, we are going to be looking for "Details about " and replacing it with empty text.

```ruby
# scraper.rb
title_element = doc.css("#itemTitle").first()
puts(title_element.text().sub(/Details about[^0-9a-z]+/i, ""))
```

For the first parameter, we are passing a regular expression as the text to search for.  Regular expressions are used to pattern match text.  We aren't going to go into detail about regular expressions since it's out of the scope of the course, but you can [play with them here](http://rubular.com/) if you want.

In Ruby, regular expressions are inside forward slashes.  The "Details about" part looks for the text "Details about".  The "[^0-9a-z]" part says any character not 0-9 or a-z.  In other words, only spaces or hidden characters.  The plus sign after the closing square bracket means one or more of the previous.  So "[^0-9a-z]+" means one or more character that isn't 0-9 or a-z.  The "i" at the end of the regular expression means to search case insensitive.  This pattern will match the "Details about" section and the spaces that follow. 

We pass an empty string (text) as the second parameter to remove the "Details about" and spaces.  Now if you run your program, you'll see the clean title printed to the terminal.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-clean-title-to-terminal.png)

Let's save this to a variable called "title".

```ruby
# scraper.rb
bid_price_element = doc.css("#prcIsum_bidPrice").first()
bid_price = bid_price_element.text()

title_element = doc.css("#itemTitle").first()
title = title_element.text().sub(/Details about[^0-9a-z]+/i, "")
```

We now have our product bid price and title.  The final piece of information we need is the number of bids.  Right click on the number of bids in the browser and inspect.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/inspecting-number-of-bids.png)

It looks like the number of bids element has an id of "qty-test", so let's use that to search for the element.

```ruby
# scraper.rb
bid_price_element = doc.css("#prcIsum_bidPrice").first()
bid_price = bid_price_element.text()

title_element = doc.css("#itemTitle").first()
title = title_element.text().sub(/Details about[^0-9a-z]+/i, "")

number_of_bids_element = doc.css("#qty-test").first
puts(number_of_bids_element.text())
```

If you run this, you'll see the number of bids printed in the terminal.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-number-of-bids-to-terminal.png)

Let's save this to a variable called "number\_of\_bids". 

```ruby
# scraper.rb
bid_price_element = doc.css("#prcIsum_bidPrice").first()
bid_price = bid_price_element.text()

title_element = doc.css("#itemTitle").first()
title = title_element.text().sub(/Details about[^0-9a-z]+/i, "")

number_of_bids_element = doc.css("#qty-test").first
number_of_bids = number_of_bids_element.text()
```

Alright, now we have the product bid price, title and number of bids.  Let's output them in a nice format so we can see the results of our web scraper. Add the following to the bottom of your "scraper.rb" file.

```ruby
# scraper.rb
puts("Title: #{title}")
puts("Bid Price: #{bid_price}")
puts("Number of Bids: #{number_of_bids}")
```

You might have notices the "#{}" in our strings.  This is called string interpolation and is used to inject variables into strings.  So the first line will print "Title: LG 49-Inch 4K Ultra HD 2160p 120Hz LED Smart TV 49UF6430".  String interpolation makes it easy to format your text.  Run your program and you should see the following.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-scraped-values-with-labels-to-terminal.png)

Our web scraper can now scrape one page, but it's way more useful to be able to scrape a bunch of pages.  To scrape more than one product page, we need to create a loop that goes through an array of product URLs and runs our scraper for each. Let's do that now.

```ruby
# scraper.rb
require("open-uri")
require("oga")

urls = [
  "http://www.ebay.com/itm/LG-49-Inch-4K-Ultra-HD-2160p-120Hz-LED-Smart-TV-49UF6430-/252675043686",
  "http://www.ebay.com/itm/New-Samsung-Smart-Tv-/201746874420",
  "http://www.ebay.com/itm/Sony-XBR-43X800D-43-Android-Smart-LED-4K-Ultra-HDTV-/222343367500"
]

urls.each do |url|
    page = open(url)
    doc = Oga.parse_html(page)

    bid_price_element = doc.css("#prcIsum_bidPrice").first()
    bid_price = bid_price_element.text()

    title_element = doc.css("#itemTitle").first()
    title = title_element.text().sub(/Details about[^0-9a-z]+/i, "")

    number_of_bids_element = doc.css("#qty-test").first
    number_of_bids = number_of_bids_element.text()

    puts("Title: #{title}")
    puts("Bid Price: #{bid_price}")
    puts("Number of Bids: #{number_of_bids}")
end
```

We are removing the "url" variable we had defined earlier and instead assigning an array of product listing URLs to the variable "urls".  In Ruby, we define arrays the same as we do in Javascript.  I put each item in the array on its own line so it's easier to read.  This is the same as putting it on the same line.

The next new part is the loop.  In Ruby, arrays have an "each" method that loops over the array's contents.  The "do |url|" portion defines a block in ruby.  This works much like a callback function in that it gets run on every loop iteration and gets passed parameter in the "|" brackets. On each iteration, our block will be passed a value from the array which we are calling "url".  To close a Ruby block, we use the keyword "end" instead of closing it with curly braces like in Javascript.

If you run this program, it will go through each URL, starting at the first one, and scrape that product listing page.  The loop will then print the values we scraped with labels.

![](https://s3.amazonaws.com/spark-school/courses/ebay-web-scraper/printing-multiple-scraped-pages.png)

We aren't going to do this in this course, but you could take this loop one step further by scraping an [auction listings page](http://www.ebay.com/sch/Televisions/11071/i.html?LH_Auction=1).  Instead of getting a single element, you would get all of the product URLs from links on the page and put them in an array to loop over.  If you name the array "urls", then there is no need to change the loop we are currently using.

That's the end of the eBay web scraper course.  As always, I hope you enjoyed the course and now understand the basics of web scraping. 

If you have any questions or feedback, feel free to leave a comment or reach out to me at shane@trysparkschool.com.  I'll be sure to personally respond to you.

Thanks for taking the course, and happy scraping!