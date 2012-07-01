# Initializing connection to Redis
RedisConnection = Redis.new( :host => AppConfig['redist']['host'], :port => AppConfig['redist']['port'] )