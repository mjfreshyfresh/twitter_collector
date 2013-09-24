Twitter Collector
==========

Ruby + [Datamapper](http://datamapper.org) based utility for collection of Twitter Friend and/or Follower data. Leverages a Token Pool (which requires additional work to gather tokens) and is controlled by [Rake](http://rake.rubyforge.org). Obeys rate limits. Utilizes the [Ruby Twitter gem](https://github.com/sferik/twitter)

In addition to data collection you can also create Node and Edge files for Graph Analysis via software such as [Gephi](https://gephi.org).

Setup
-----
In the [Twitter Developers Portal](https://dev.twitter.com) you need to create an app and get the credentials required to run read only application.

Create a secrets.txt file and fill it with the following content which you received via the Twitter Developer Portal

	APP_NAME = 'AnyThingYouWantAlsoDBName'
	DATA_FILE = './data/accounts.txt'
	CONSUMER_KEY = '3.141592653589793238462643'
	CONSUMER_SECRET = '3.141592653589793238462643'

	SAMPLE_TOKEN = '3.141592653589793238462643'
	SAMPLE_SECRET = '3.141592653589793238462643'


Basic Usage
-----------

	bundle exec rake bootstrap 			# Create db
	bundle exec rake load_data 			# load a file of twitter handles to collect data on
	bundle exec rake fetch_friends 		# fetch friend data of predefined twitter handles
	bundle exec rake fetch_followers 	# fetch follower data of predefined twitter handles
	bundle exec rake export_data 		# write out Node and Edge files


LICENSE
-------

Copyright (c) 2010 [Michael Jones aka MJ](http://mjfreshyfresh.com/about) and
distributed under the MIT license. See the `COPYING` file for more info.