# Initializing connection to Redis
uri = URI.parse( AppConfig['redist_url'] )
RedisConnection = Redis.new( :host => uri.host, :port => uri.port, :password => uri.password )