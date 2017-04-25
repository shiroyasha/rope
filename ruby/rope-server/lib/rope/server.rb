require "yaml"
require "rope/server/version"

require_relative "service"

module Rope
  class Server

    def self.start(entrypoint, options)
      load entrypoint

      host = options[:host] || "localhost"
      port = options[:port] || 3000
      path = options[:service] || "service.yml"

      service = Rope::Service.new(path)

      puts "#{service.name.upcase} listening on host:#{port}"
    end

  end
end
