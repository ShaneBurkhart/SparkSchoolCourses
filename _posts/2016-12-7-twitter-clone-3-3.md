---
layout: default
permalink: /courses/twitter-clone/3/3
title: 3.3 Inserting Some Tweets Into Our Database
course: Twitter Clone
section: 'Day 3: Creating And Saving Tweets'
next-lesson-link: /learn/courses/twitter-clone/3/4
---

####Table Of Contents

- [3.1 Connecting To MySQL](/learn/courses/twitter-clone/3/1)
- [3.2 Creating The Database And Tweets Table](/learn/courses/twitter-clone/3/2)
- **3.3 Inserting Some Tweets Into Our Database**
- [3.4 Connecting The Tweet Form To Our Web Server](/learn/courses/twitter-clone/3/4)

Right now, our table doesn't contain any data.  Unfortunately, our form isn't working yet, but we can insert tweets manually by running SQL queries in our MySQL GUI.

To insert rows into tables, we use the INSERT INTO command.  When we created the Tweets table, we gave the "id" and "created\_at" columns default values.  Since the id and created\_at columns are pre populated with default values, we only need to insert the user handle and the body of the tweet.  I'm going to use my Twitter handle in this case.  Run this command in your MySQL GUI and I'll explain it in a minute:

```sql
-- SQL GUI Query Tab
INSERT INTO Tweets(handle, body) VALUES('DonkkaShane', 'Having a great time teaching this Twitter clone course!');
```

The first part, "INSERT INTO Tweets", tells MySQL which table to insert into.  After that, we give the columns we are inserting values for in parenthesis separated by commas.  Following that, we type the VALUES keyword followed by the values to put in those columns in parenthesis.  Since the values are text, we surround them in single quotes.  Notice that the order of the values we are inserting is the same as the order we defined them earlier in the query.  After running that command, we now have a tweet in our table.

To see our Tweets, we can run the following SQL command in our MySQL GUI.  We'll go over this command later, but for now, just use it to see the contents of the Tweets table.

```sql
-- SQL GUI Query Tab
SELECT * FROM Tweets;
```

You can rerun the INSERT INTO command to create more tweets.  Try adding a Tweet with your Twitter handle.  I'm going to add another tweet from myself:

```sql
-- SQL GUI Query Tab
INSERT INTO Tweets(handle, body) VALUES('DonkkaShane', 'Yogi is the best dog in the world!');
```

We now know how to create Tweets in our database, but right now, we are doing it manually in our GUI.  Let's do this in code.
