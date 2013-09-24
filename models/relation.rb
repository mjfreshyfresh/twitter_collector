class Relation
    
  # MJ (from) follows VA (to)
  include DataMapper::Resource
  property :id, Serial
  property :account_from_id, Integer
  property :account_to_id, Integer  
          
end