require "rope/server"

Rope::Server.async_engine = { :engine => :amqp, :url => ENV["amqp_url"] }

class UserMailer < Rope::Server

  def send_thanks_for_signing_up(username)
    Rope.logger.info "Sending signup mail to #{username}"

    sleep 2 # simulate long processing time
  end

  def send_purchase_confirmed(username, plan)
    Rope.logger.info "Sending purchase mail to #{username}. Plan: #{plan}"

    sleep 2 # simulate
  end

end
