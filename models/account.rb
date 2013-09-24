class Account
    
  include DataMapper::Resource

  property :id, Serial
  property :twitter_handle, Text
  property :deets, Text  
  property :followers, Boolean, :default  => false  
  property :friends, Boolean, :default  => false        
  property :collect_on, Boolean, :default  => false          
  
end