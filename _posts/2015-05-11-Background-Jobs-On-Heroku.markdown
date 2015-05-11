---
layout: post
title:  "Rails background Workers on Heroku Free"
date:   2015-05-11 10:31:11
categories: jekyll update
---

#Rails Background Workers

Background Workers
---

Background workers are separate processes that can run along side a Rails server.

The rails server can send seperate jobs to the background workers that they can do to provide a fast experience for your users.


You can also schedule these jobs to run at a later time, for example say you want to archive posts after 30 days.

A common example is sending a welcome email, you wouldnt want the user to have to wait for your server to send an email before the page redirects them after they sign up, instead you would send that task to a worker.
Take 5minutes and think up some use cases for background workers

Luckily, heroku just changed its pricing scheme and now lets us have a worker for free, and thats what we're going to do today.

###Install Redis,

We're going to be using a task worker called sidekiq, its the industry standard and incredibly powerful.
It uses redis a database to store its tasks. To install redis, `$ brew isntall redis` and read the instructions it gives you and follow them.
Check that redis is working with `$ redis-cli ping`

###Starter code
clone the starter repo off of github here
<https://github.com/RobAWilkinson/backgroundjobs-STARTER-code>

###Set up Sidekiq

we need to add the sidekiq gem into our gemfile and then bundle install.
we need to tell rails to use sidekiq for ActiveJob

~~~ ruby
# config/application.rb
module SidekiqApp
  class Application < Rails::Application
    config.active_job.queue_adapter = :sidekiq
  end
end
~~~

Now I want you to open up a seperate tab and run `bundle exec sidekiq` inside your rails directory.
if it says that it is ready to accept jobs, you're in the clear.

we need a few more gems to make this work on heroku though so go ahead and add these gems in
include `redis`, `sidekiq`, `rails_12factor`, `thin` and `geocoder` gem

bundle install

and run `$ rails generate geocoder:config`.

Now that we have the geocoder gem in there, we can open up our rails console and do something like this

~~~
Geocoder.search("91770")
~~~
Thsi returns a result object that you can pull latitude, longitude, city and state from.
###Making a worker

Now that we've got that working we're going to convert that process to something that a worker does so we dont have to worry about long reload times.

We're going to do this using rails 4.2 active jobs, like most things in rails it comes with a generator

`$ rails g job geolocate_account`

Now this will generate a job with a `#perform` method, make it so this method takes an `Account` does a Geocoder search by its zipcode and saves all the new data it finds.


~~~ ruby
 def perform(account)
    result = Geocoder.search(account.zipcode).first
    if result
      account.latitude  = result.latitude
      account.longitude = result.longitude
      account.city = result.city
      account.state = result.state
      account.save!
    end
  end
~~~

To use this in our controller we just call

~~~ ruby
def create
  account = Account.new(params.require(:account).permit(:name, :zipcode))
  account.save
  GeolocateAccountJob.perform_later(account)
end
~~~

And voila, rails makes it that easy.

We can call a job to run at a set time as well, for example to archive an article, mail an email or something
Set this up by calling the job like so

~~~ ruby

GeolocateAccountJob.set(wait_until: Date.tomorrow.noon).perform_later
GeolocateAccountJob.set(wait: 1.week).perform_later
~~~

Create a new job that converts an account to pro after it is 5 minutes old

###Getting this on heroku

Steps to make it work in heroku
First we create our new heroku application

~~~
$ heroku create
~~~

Then we have to enable redis on heroku, and set sidekiq's redis url to the one heroku gives us

~~~
$ heroku addons:create redistogo
$ heroku config:set REDIS_PROVIDER=REDISTOGO_URL
~~~

Lastly we go on heroku enable the beta pricing and switch our free worker on.

Then we have to add a procfile to tell that worker what to do


~~~ ruby
#procfile
web: bundle exec thin start -p $PORT
worker: bundle exec sidekiq
~~~
