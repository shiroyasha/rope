require "rope/server"

class Tester < Rope::Server

  def sync_test(username)
    sleep 2 # simulate long processing time
  end

  def async_test(username, plan)
    sleep 2 # simulate
  end

end
