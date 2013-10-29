require File.join(File.expand_path(File.dirname(__FILE__)), 'environment.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), 'collector.rb')

desc "DESTRUCTIVE: Does it all and a bag of chips!"
task :boom => [:bootstrap, :sample_token, :load_data, :fetch_friends, :export_data]

desc "DESTRUCTIVE bootstrap of the database (e.g. rake bootstrap)"
task :bootstrap do
  puts "Bootstrapping database."
  ::DataMapper.auto_migrate!
end

desc "Load a sample token"
task :sample_token do
  puts "Loading Sample Token..."
  Token.create(
        :token=>SAMPLE_TOKEN, 
        :secret=> SAMPLE_SECRET
        )
  puts "DONE"
end

desc "Run test code..."
task :test do
  puts "Running Twitter Tests..."
  s = Collector.new
  s.test
  puts "DONE"
end

desc "Load Data from file"
task :load_data do
  puts "Loading Data..."
  c = Collector.new  
  c.load_data
  puts "DONE"
end

desc "Fetch Follower Data from Twitter"
task :fetch_followers do
  puts "Fetching Follower Data..."
  s = Collector.new  
  s.fetch(:followers)
  puts "DONE"
end

desc "Fetch Friend from Twitter"
task :fetch_friends do
  puts "Fetching Friend Data..."
  s = Collector.new  
  s.fetch(:friends)
  puts "DONE"
end

desc "Parse JSON Account Object and populate db"
task :expand do
  puts "Expanding Account Data..."
  accounts = Account.all
  accounts.each do |account| 
    account.foller_count = account.deets.parse('//followers')
    
  end
  s.fetch(:friends)
  puts "DONE"
end


desc "Writing out Node and Edge Files"
task :export_data do
  puts "Writing Node Data..."
    
  accounts = Account.all
  output = File.open( "./data/nodes.csv", "w+" )
  output << "Id,Label\n"  
  accounts.each do |account|
    output << "#{account.twitter_handle},#{account.twitter_handle}\n"
  end
  output.close  
  
  puts "Writing Edge Data..."  
  accounts = Account.all(:collect_on=>true)   
  output = File.open( "./data/edges.csv", "w+" )
  output << "Source,Target\n"  
  accounts.each do |account|
    Relation.all(:account_from_id=>account.id).each do |relation|
      output << "#{Account.get(relation.account_from_id).twitter_handle},#{Account.get(relation.account_to_id).twitter_handle}\n"
    end
    output << "\n"
  end
  output.close
  
  puts "DONE"
end
