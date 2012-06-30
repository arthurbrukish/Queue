# Tasks message entry with finish time and description fields
# @author - Arthur Brukish ( abrukish@gmail.com )
class TaskMessage

  attr_accessor :finish_time, :description

  # Constructor
  def initialize( options )

    time = options[:finish_time]

    # If not time provided - expecting for a string Time version
    time = Time.parse( options[:finish_time].to_s ) unless time.is_a?(Time)

    self.finish_time = time
    self.description = options[:description]

  end

  # JSON string representation for Redis storage
  def to_redis

    # Hash representation
    representation = {
      finish_time: finish_time,
      description: description
    }

    representation.to_json.to_s

  end

  # Static parse method from Redis string representation
  def self.from_redis( serialized )

    # Parse as JSON
    parsed = JSON.parse( serialized ).symbolize_keys

    TaskMessage.new( parsed )

  end

end