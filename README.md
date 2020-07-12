# README

*** Ruby version**
ruby '2.6.1'

------------


*** Rails version**
'rails', '~> 6.0.3', '>= 6.0.3.2'

------------

*** System dependencies**

------------

*** Configuration**

------------

*** Database creation**

------------

*** Database initialization**
Production data base
"rails db:create" : to create data base
"rails db:migrate" : to migrate our data base

DEV data base 
"rake db:create RAILS_ENV=test" : to create test data base
"rake db:migrate RAILS_ENV=test" : to migrate test data base
"rails c -e test" : access to the test data base console

------------

*** How to run the test suite: ***

"rspec" to run all the test suits
"rspec --only-failures" to run only the failing tests

------------

*** Services (job queues, cache servers, search engines, etc.)**

------------

*** Deployment instructions**

------------

* ...
