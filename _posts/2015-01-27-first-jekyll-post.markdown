---
layout: post
title:  "Introducing Postgres"
date:   2015-01-27 10:31:11
categories: jekyll update
---

Today was the first day that my class had to get down and dirty with postgresql. It was a huge sea change for the students and a definite paradigm shift.

I've noticed that even though the GA curriculum can be broadly split between two categories, Javascript and Rails, there is a definite pattern with the way we introduce databases as well.  

*  JSON - NoDB database  
*  Mongod - NoSql JSON-like DB

*  PostGres - full SQL database  

---

###Its a scaffolded learning pattern

Today we started with a postgres install fest in the morning. Even though all the students have homebrew installed, theres the inevitable permissions conflict, the upgrading of pg, and the need to run `initdb` in the proper folder. Configuration hiccups are never fun, but (hopefully) never need to be dealt with again if configured properly at first. 

Next we hopped right into some simple pg commands, `\l` to list all database, `\c` to connect to a database, and `\d` to describe a table.


###Onward to Migrations!

Coming from a NoSQL DB its a huge shift in creating proper tables, and data normalisation.

I've always thought the best way to explain this is to throw up a ton of data and just start removing duplicate entrys into other tables, if you keep doing this until nothing appears twice you eventually have a completely normalized schema.

###Relations

I structured relations so that I started out with `belongs_to` then created `has_one` then `has_many`. It was tough explaining why one would only have a belongs_to or a has_many relation without the parallel one in the child/parent model. I used the example of a Customer who has an address, we will never need to look up a Customer from an address so we only need to define the parent child relation. 
I was hoping to go in this order to show that the migration looks exactly the same for `has_many`, `has_one`, and `belongs_to`. The foreign key index resides in the child table for all three.
Didnt have a chance to reach has_and_belongs_to_many relations today, leave that lesson for another day, it seems like it will be an hour and  half just on that topic alone!

### Learning how to learn
Had an amazing seminar on learning how to learn, I felt like the students got a lot out of it, I hope they put their new methods into action.

