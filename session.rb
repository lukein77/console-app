require_relative 'utils.rb'

class Session
  attr_accessor :username, :start_time

  def initialize(username)
    @username = username
    @start_time = get_current_time
  end
end