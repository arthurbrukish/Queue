# Tasks queue by finish date implementation
# @author - Arthur Brukish ( abrukish@gmail.com )
class TaskQueue

  # Singleton pattern
  include Singleton

  # Adding new task
  def push( task )

    @redis.sadd( key, task.to_redis )

  end

  # Getting first from expired tasks ( most expired )
  # otherwise nil will be returned
  def pop

    # Jump out if no expired task available
    return if expired_tasks.empty?

    # They are already sorted by finish_time descending
    task = expired_tasks.first

    # Remove found one from Redis
    @redis.srem( key, task.to_redis )

    task

  end

  # Getting task specified by finish time if no expired tasks available
  # otherwise - return first from them
  def get_task( finish_time )

    return pop if expired_tasks.present?

    tasks.find {|t| t.finish_time == finish_time }

  end

  # All tasks that are in the queue now
  def tasks

    # Converting list of serialized tasks to array of TaskMessage
    task_messages = @redis.smembers( key ).map {|t| TaskMessage.from_redis( t ) }

    # Sort them descending via finish_time
    task_messages.sort {|x, y| y.finish_time <=> x.finish_time }

  end

  # All expired tasks that are in the queue now
  def expired_tasks

    tasks.select {|t| t.finish_time < Time.now }

  end

  private

    # Private constructor
    def initialize

      # Initializing connection to Redis
      @redis = Redis.new( :host => AppConfig['redist']['host'], :port => AppConfig['redist']['port'] )

    end

    # Redis key
    def key
      "queue"
    end

end