class QueueController < ApplicationController

  def index

    @queue = TaskQueue.instance

    @tasks = @queue.tasks

  end

end