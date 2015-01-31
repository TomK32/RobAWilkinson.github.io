---
layout: post
title: Düber and Activerecord
---

##Finishing Activerecord Relations.

I had the joyous task today of finishing up ActiveRecord migrations and relations, I forced my class to do it the hard way, we built our models all wrong and then used `rails g migration` and created migrations to fix everything, I figured that they'll need to do it in the real world, they might as well now.

###Has_and_belongs_to_many
Teaching `has_and_belongs_to_many` actually went pretty well, I took the example of a fun app we had built on Wednesday, Duber, Uber for Dogs. 

We had Three models Dogs, Owners, and Drivers.

I started by drawing up the Dogs table on the wall with real life dogs that the students had, and then I drew up their owners table with their respective owners. Luckily one student in my class had both multiple dogs and was married so my example worked, a dog had many owners, and a owner had many dogs. 

When I drew up the tables I asked the Students how these two models would relate to each other, at first someone says, "Add a `owner_id` field to the Dogs table" so we tried that and saw that that wasn't normalized, then we did it the other way around and saw that they wasn't normalized, only when we had exhausted all the ways we knew did I actually draw up an external table that referenced the two models.

###Cyclical Relations

Also another instructor on Campus had a chance to touch on self referential associations which is something that I've never really used, basically what happens if a User has many friends, who are all Users. If you use an external table you end up with two exact named columns. What you end up doing is creating a relationship and defining that a User `has_many :users, class 'Friend'`. That way you can call `User#friends` and it returns a collection of users. The table ends up relating a `user_id` with a `friend_id` which is really a User id.

###Code reviews
All in all great day, just need to finish off code reviews tomorrow to finish off the week, gotta give student enthusiasm a little shot in the arm too, seems to be waning in week 7.
