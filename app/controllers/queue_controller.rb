class QueueController < ApplicationController

  before_filter :set_queue

  def index

    @tasks = @queue.tasks

  end

  def create

    @task_message = TaskMessage.new( params[:task] )

    @queue.push( @task_message )

    @tasks = @queue.tasks

    render :index

  end

  def pop

    @task_message = @queue.pop

    @tasks = @queue.tasks

    render :index

  end

  def get_task

    @task_message = @queue.get_task( params[:task][:finish_time] )

    @tasks = @queue.tasks

    render :index

  end

  private

    def set_queue

      @queue = TaskQueue.instance

    end

end