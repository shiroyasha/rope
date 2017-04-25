require "yaml"
require "rack"
require "rope/server/version"

require_relative "service"

module Rope
  class Server

    def self.start(entrypoint, options)
      host = options[:host] || "localhost"
      port = options[:port] || 3000
      path = options[:service] || File.join(Dir.pwd, "service.yml")

    end

  end
end
