require File.join(File.expand_path(File.dirname(__FILE__)), 'environment.rb')

# Main class for Twitter data collection
class Collector
  
  attr_accessor :tokens, :token_depth

  def initialize
    @tokens = Token.all
    @token_depth = 0
    puts "Collection starting with #{@tokens.size} tokens"
    nil
  end
  
  # Simple test to make sure things are wired up
  def test
    u = get_client.followers('mjfreshyfresh')
    puts u.inspect
    nil
  end

  # Loads flatfile of accounts into DB for collection
  def load_data
    File.open(DATA_FILE).each do |line|
      puts "#{line}"
      Account.create(:twitter_handle=>line.downcase.strip,:collect_on=>true)
    end 
    nil
  end
    
  # Pass in a symbol to fetch, must be :friends || :followers
  def fetch(relation_type)
    client = get_client
    accounts = Account.all(relation_type => false, :collect_on => true)
    accounts.each do |account|
      puts "[START] #{account.twitter_handle}"              
      cursor = -1         
      count = 0       
      while cursor != 0
        begin
          page = client.send(relation_type, account.twitter_handle, {:cursor => cursor})
        rescue Twitter::Error::TooManyRequests
            sleep rand_num
            client = get_client
            retry
        end
        results = page.users
        results.each do |result|
          temp_account = Account.first_or_create(:twitter_handle=>result.screen_name.downcase)

          if relation_type == :followers
            account_from_id = temp_account.id
            account_to_id = account.id
          else
            account_from_id = account.id            
            account_to_id = temp_account.id
          end
          
          if Relation.first(:account_from_id=>account_from_id, :account_to_id=> account_to_id)
            puts "[DUP] from: #{account_from_id} to: #{account_to_id}"
          else            
            count = count + 1
            Relation.create(:account_from_id=>account_from_id, :account_to_id=> account_to_id)
            puts "#{count}: #{Account.first(:id=>account_from_id).twitter_handle} ->  #{Account.first(:id=>account_to_id).twitter_handle}"
          end        
        end     
        cursor = page.next_cursor
      end          
      Account.first(account.id).update(relation_type => true)
      puts "[COMPLETED] #{relation_type} for #{account.twitter_handle}"
    end
    puts "[DONE]"
    nil
  end
  
private
  
  # Provides a Twitter client with a valid Token
  def get_client
    t = @tokens[@token_depth]
    @token_depth = @token_depth + 1
    if t.nil?
      puts "[#{Time.now}] #{@token_depth} in and Out of Tokens. Waiting at 15mins. Grab a cup of joe."
      sleep rand_num(900)
      @tokens = Token.all
      @token_depth = 0
      t = @tokens[@token_depth]      
      puts "[#{Time.now}] We're back up! Starting #{@token_depth} with #{@tokens.size} fresh ones."      
    end
    puts "New Token: #{t.id}"    
    client = Twitter::Client.new(    
      :consumer_key => CONSUMER_KEY,
      :consumer_secret => CONSUMER_SECRET,
      :oauth_token => t.token,
      :oauth_token_secret => t.secret
    )
    client
  end
  
  # Return a random 1-5
  def rand_num(value=0)
    value + [1,2,3,4,5].sample
  end
  
end