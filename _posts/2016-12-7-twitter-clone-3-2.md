---
layout: default
permalink: /courses/twitter-clone/3/2
title: 3.2 Creating The Database And Tweets Table
course: Twitter Clone
section: 'Day 3: Creating And Saving Tweets'
next-lesson-link: /courses/twitter-clone/3/3
---

####Table Of Contents

- [3.1 Connecting To MySQL](/courses/twitter-clone/3/1)
- **3.2 Creating The Database And Tweets Table**
- [3.3 Inserting Some Tweets Into Our Database](/courses/twitter-clone/3/3)
- [3.4 Connecting The Tweet Form To Our Web Server](/courses/twitter-clone/3/4)

We are now connect to our MySQL server, but we don't have a database yet.  In this section, we'll be creating a database and a table in that database called "Tweets".  Before we can do this, let's go over what databases are and how they work.

###Understanding Databases

A database is a collection of data that is organized so that it's easy to read, write, update and destroy data.  There are many ways to organize data and different database formats are better at some things than others.

For our database, we are going to use a fairly general purpose database called MySQL.  MySQL is a relational database that is commonly used around the industry.  A relational database formats it's data so that it's easy to find related data quickly.  An example of related data would be a Tweet would have a User related to it that created the Tweet.

Relational databases like MySQL are made up of tables.  Tables are used to contain specific sets of information.  For instance, we could have a table for Tweets and another table for Users.  In this course, we are only going to have a single "Tweets" table.

Tables are made up of columns that define what data we want to store and rows that are each entry in our table.  For our "Tweets" table, we are going to have "handle" and "body" columns since we want to store those values and each row will be a tweet.  Our "Tweets" table could look like the following.  The first row is the column names and the rest are rows each containing an individual tweet.

![](https://s3.amazonaws.com/spark-school/courses/twitter-clone/3/tweets-table-example.png)

To read and modify this data, we use the SQL query language.  MySQL uses the SQL language to run queries on the database.  We will learn the different queries as we go, and all you need to know right now is that every SQL query ends with a semicolon.

###Creating Our Database

Right now, we are connected to the MySQL server but don't have a database for our project yet.  Creating databases is pretty straightforward and can simply be done with the "CREATE DATABASE" command.

Let's create a database for our project with the name "twitter".  Run the following command in your MySQL GUI:

```sql
-- SQL GUI Query Tab
CREATE DATABASE twitter;
```

We've created our database, now we need to select it as the database we want to use right now. We do that with the "USE" command, followed by the name of the database:

```sql
-- SQL GUI Query Tab
USE twitter;
```

With the "twitter" database selected, we can now create tables in the selected database.

###Creating The Tweets Table

We need to decide on a name for our table.  Generally you name it what the table contains.  For instance, our tables holds tweets so we are going to call it "Tweets".  Table names are generally plural since they hold more than one entry and are capitalized.

We have a name for our table, but now we need to think about the data we want to store for our tweets.  At minimum, we need columns for the handle of the user that created the tweet and the text body of the tweet.  We also need a way to uniquely identify a tweet, so we need another column for an id.  We also want to store the date the tweet was created so we can display it with the tweet. So we'll need four columns: "id", "handle", "body", and "created_at".

Now that we know what data we want to store, we can create a table with those columns in it.  Run this query in your MySQL GUI and  I'll explain it in a bit:

```sql
-- SQL GUI Query Tab
CREATE TABLE Tweets (
  id INT NOT NULL AUTO_INCREMENT,
  body TEXT NOT NULL,
  handle VARCHAR(15) NOT NULL,
  created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);
```

The whole section is one query, but we format it with tabs and newlines to make it easier to read.  The semicolon marks the end of the query.

The "CREATE TABLE Tweets" part is telling MySQL to create a table named "Tweets".  After that is the table definition inside parenthesis.  Each column is on a it's own line so it's easier to read.

The first line in the definition defines the "id" column as an INT which is short for integer.  The "NOT NULL" part says it can't be null or in other words there has to be a value.  The AUTO_INCREMENT part means that the column will be automatically set to an auto incrementing number starting at 1.  So the first row inserted will get an id of 1, the second a 2, and so on. This ensures each Tweet gets a unique id.

The next column is the body column and it's much simpler.  We give it a type of TEXT and make sure it's NOT NULL.

The "handle" column is of the VARCHAR type.  This stand for variable characters and the number in the parenthesis is the maximum number of characters it can be.

Why use VARCHAR over something like TEXT?  The database can optimize VARCHAR better than TEXT since it knows the max size possible.  So to keep things efficient, we use VARCHAR since Twitter handles can't be longer than 15 characters.

The last column is the "created_at" column and it is of the TIMESTAMP type.  Timestamps columns store a specific moment in time. As before, we want to make sure it's NOT NULL and this time we are giving it a default of the CURRENT_TIMESTAMP.  This will set the "created_at" column to the current time when a row is created.

The last line in the definition tells MySQL which column is the PRIMARY KEY for the table.  The PRIMARY KEY is the column we use to uniquely identify rows and in our case it's the "id" column.  It also helps optimize when searching by id.
