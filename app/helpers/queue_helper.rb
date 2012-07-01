module QueueHelper

  def task_message_details( task )

    "[#{action_name}] Finish Time - #{ task.finish_time }, Description - #{ task.description }"

  end

end