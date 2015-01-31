---
layout: post
title: "Postgres HSTORE, VIM fun...and More"
---

###Student presentations!
Today was the day for students to pitch their project 2s, Its so exciting seeing what they are shooting for when they barely knew how to write a single function 2 months ago.

###Learning to teach

Couple quick Concepts that I noticed today, my journey right now from coder to teacher hasn't been the easiest but I feel that I'm learning more and more every day. A few things that I've noticed  

* Bring back the parking lot!
  * I introduced the concept a while back of a "Parking Lot" basically a place to put tangent ideas to discuss later without derailing the lesson. Theres things that you want to talk about but you don't want it to derail the lesson or detract from the main goal of the day.
* No more tangents, as a coder I get super excited about code concepts and if someone else is excited about them too I could spend hours talking about it, This is great if I have unlimited time but its a bad philosophy to follow when you're leading a lesson.
* Say "Don't worry about that right now" 
  * A lot of times I'll barely touch on a topic because I know I'm going to spend time on it down the line. I forget that the students don't know that though, they just think they missed a super critical concept.

### The power of Postgres

All of the students are building apps that involve external API calls to create their own APIs. One of the gems they're using for soundcloud returns the data as a [Hashie Mash](http://www.ruby-doc.org/gems/docs/z/zerobearing-hashie-0.1.9/README_rdoc.html) its a super cool way to extend ruby's base Hash and give it some pseudo object functionality. We take this object from the API, convert it to a regular Hash and then save it to the database. 
**Enter Postgres**
Postgres' hstore datatype is [bad ass](http://www.postgresql.org/docs/9.0/static/hstore.html), I'd never used it before and I don't think I could ever go back.
Add an initial migration

~~~ ruby
  def up
    enable_extension "hstore"
  end
  def down
    disable_extension "hstore"
  end
~~~ 

The big downside is that you end up with non normalized data, but with an external api that can change its nicer to save it as hstore rather than to change your migrations all the time.
