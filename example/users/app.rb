require "rope/server"

$user_mailer = Rope.new(ENV["USER_MAILER_URL"])
$events = Rope.new(ENV["ENENTS_URL"])

ActiveRecord::Base.establish_connection(ENV["DB_URL"])

class User < ActiveRecord::Base
  def serialize
    {
      :username => username,
      :email => email,
      :created_at => created_at,
      :updated_at => updated_at,
      :confirmed => confirmed?
    }
  end
end

Rope::Server.async_engine = { :engine => :amqp, :url => ENV["amqp_url"] }

class Users < Rope::Server

  def list_all
    User.all.map(&:serialize)
  end

  def list(pattern)
    User.where(:username => pattern).map(&:serialize)
  end

  def register(username, email)
    if User.find_by_username(username)
      return { :success => false, :reason => "Username already taken" }
    end

    if User.find_by_email(email)
      return { :success => false, :reason => "Email already taken" }
    end

    user = User.create(:username => username, :email => email)

    $events.record("user_signup")
    $user_mailer.send_thanks_for_signing_up(username)

    { :success => true, :reason => nil }
  end

  def deregister(username)
    user = User.find_by_username(username)

    return false unless user

    user.destroy

    $events.record("user_deregistered")
    $user_mailer.ask_why_are_you_leaving(username)
  end

end
