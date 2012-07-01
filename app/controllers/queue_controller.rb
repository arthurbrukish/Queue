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

  rescue

    redirect_to root_path

  end

  def pop

    @task_message = @queue.pop

    @tasks = @queue.tasks

    render :index

  end

  def get_task

    time = Time.parse( params[:task][:finish_time] )

    @task_message = @queue.get_task( time )

    @tasks = @queue.tasks

    render :index

  rescue

    redirect_to root_path

  end

  private

    def set_queue

      @queue = TaskQueue.new

    end

end