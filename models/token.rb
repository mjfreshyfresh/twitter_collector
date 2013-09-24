class Token
    
  include DataMapper::Resource
  validates_uniqueness_of :token

  property :id, Serial
  property :token, Text    
  property :secret, Text
  property :deets, Text
          
end