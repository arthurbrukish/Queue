# Tasks queue by finish date implementation
# @author - Arthur Brukish ( abrukish@gmail.com )
class TaskQueue

  # Singleton pattern
  # include Singleton

  # Adding new task
  def push( task )

    RedisConnection.sadd( key, task.to_redis )

  end

  # Getting first from expired tasks ( most expired )
  # otherwise nil will be returned
  def pop

    # Jump out if no expired task available
    return if expired_tasks.empty?

    # They are already sorted by finish_time descending
    task = expired_tasks.first

    # Remove found one from Redis
    RedisConnection.srem( key, task.to_redis )

    task

  end

  # Getting task specified by finish time if no expired tasks available
  # otherwise - return first from them
  def get_task( finish_time )

    return pop if expired_tasks.present?

    # If not time - expecting for a string Time version
    finish_time = Time.parse( finish_time.to_s ) unless finish_time.is_a?(Time)

    task = tasks.find {|t| t.finish_time == finish_time }

    # Return nil if nothing found
    return if task.nil?

    # Remove found one from Redis
    RedisConnection.srem( key, task.to_redis )

    task

  end

  # All tasks that are in the queue now
  def tasks

    # Converting list of serialized tasks to array of TaskMessage
    task_messages = RedisConnection.smembers( key ).map {|t| TaskMessage.from_redis( t ) }

    # Sort them ascending via finish_time
    task_messages.sort {|x, y| x.finish_time <=> y.finish_time }

  end

  # All expired tasks that are in the queue now
  def expired_tasks

    tasks.select {|t| t.finish_time < Time.now }

  end

  # Clearing all tasks in queue
  def clear
    RedisConnection.del( key )
  end

  private

    # Redis key
    def key
      "task_queue"
    end

end