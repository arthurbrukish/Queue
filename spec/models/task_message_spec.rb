require File.dirname(__FILE__) + '/../spec_helper'

describe TaskMessage do

  it "should be properly converted to Redis" do

    time = 5.days.ago

    redis_representation = TaskMessage.new( finish_time: time, description: 'foo' ).to_redis

    redis_representation.should include( time.to_json.to_s )
    redis_representation.should include( 'foo' )

  end

  it "should be properly parsed from Redis" do

    primal_task = TaskMessage.new( finish_time: 5.days.ago, description: 'foo' )

    secondary_task = TaskMessage.from_redis( primal_task.to_redis )

    secondary_task.should eq( primal_task )

  end

  it "should be compared right" do

    time = 5.days.ago

    first_task = TaskMessage.new( finish_time: time, description: 'foo' )
    second_task = TaskMessage.new( finish_time: time, description: 'foo' )

    first_task.should eq( second_task )

  end

end