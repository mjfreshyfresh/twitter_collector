require File.join(File.expand_path(File.dirname(__FILE__)), 'environment.rb')
require File.join(File.expand_path(File.dirname(__FILE__)), 'collector.rb')


desc "Export Circos Data Sets"
task :export_circos do
  
  # replace with the source ids you wish to display
  source_ids = [1, 3, 4, 5, 6, 8, 9, 10, 2, 7]
  # replace with the target ids you wish to display  
  target_ids = [841, 1351, 782, 1394, 1413, 811, 17, 1219, 1412, 288, 1824, 1343, 795, 780, 44, 784, 1375, 832, 35, 1397]
  
  sources = Account.all(:id=>source_ids)
  targets = Account.all(:id=>target_ids)  
  output = File.open( "./data/circos.txt", "w+" )  
  output << "labels "
  sources.each{|account| output << "#{account.twitter_handle.strip.upcase[0..8]} "}
  output << "\n"  

  targets.each do |target|
    output << "#{Account.first(:id=>target.id).twitter_handle.strip[0..8]} "
      sources.each do |account|      
        output << "#{Relation.first(:account_from_id=>account.id, :account_to_id=>target.id).nil? ? 0 : 1} "
      end
    output << "\n"      
    end
  output.close  
end


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
