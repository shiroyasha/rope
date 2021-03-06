require "rope/server"

ActiveRecord::Base.establish_connection(ENV["DB_URL"])

class Event < ActiveRecord::Base
  def serialize
    {
      :name => name,
      :created_at => created_at
    }
  end
end

class UserMailer < Rope::Server
  async_engine :engine => :amqp, :url => ENV["ampp_url"]

  def record(name)
    Event.create(:name => name)
  end

  def count(name, from, to)
    Event.where(:name => name).where(:created_at => [from..to]).count
  end

  def list(name, from, to)
    Event.where(:name => name).where(:created_at => [from..to]).map(&:serialize)
  end
end

UserMailer.start(ARGV)
