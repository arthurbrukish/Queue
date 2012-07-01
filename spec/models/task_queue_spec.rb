require File.dirname(__FILE__) + '/../spec_helper'

describe TaskQueue do

  before :each do
    @queue = TaskQueue.new

    @queue.clear
  end

  context "should push" do

    it "task" do

      task = TaskMessage.new( finish_time: 5.days.from_now, description: 'foo' )

      @queue.push( task )

      @queue.tasks.should have( 1 ).item
      @queue.tasks.should include( task )

    end

    it "expired task" do

      expired_task = TaskMessage.new( finish_time: 5.days.ago, description: 'foo' )

      @queue.push( expired_task )

      @queue.tasks.should have( 1 ).item
      @queue.expired_tasks.should include( expired_task )

    end

  end

  context "should pop" do

    it "proper task" do

      task = TaskMessage.new( finish_time: 5.days.ago, description: 'foo' )

      @queue.push( task )

      poped_task = @queue.pop

      poped_task.should_not be_nil
      poped_task.should eq( task )

    end

    it "nil" do

      task = TaskMessage.new( finish_time: 5.days.from_now, description: 'foo' )

      @queue.push( task )

      poped_task = @queue.pop

      poped_task.should be_nil

    end

  end

  context "should get" do

    it "proper task" do

      # A bit tricky here: whe you use Time.now ( in any kind of it ) this test will fail
      # because they are not equal for some reason ( I have some ideas, but not sure ).
      # So, lets make it work just using parsed version of a string representation.
      time = Time.parse( 5.days.from_now.to_s )

      task = TaskMessage.new( finish_time: time, description: 'foo' )

      @queue.push( task )

      got_task = @queue.get_task( time )

      got_task.should_not be_nil
      got_task.should eq( task )

    end

    it "expired task" do

      task = TaskMessage.new( finish_time: 5.days.from_now, description: 'foo' )
      expired_task = TaskMessage.new( finish_time: 5.days.ago, description: 'foo' )

      @queue.push( task )
      @queue.push( expired_task )

      got_task = @queue.get_task( task.finish_time )

      got_task.should_not be_nil
      got_task.should eq( expired_task )

    end

  end

  it "should be cleared" do

    task = TaskMessage.new( finish_time: 5.days.from_now, description: 'foo' )

    @queue.push( task )

    @queue.clear

    @queue.tasks.should be_empty

  end

end