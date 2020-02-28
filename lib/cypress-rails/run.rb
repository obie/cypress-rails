require_relative "finds_bin"
require_relative "starts_rails_server"

module CypressRails
  class Run
    def initialize
      @starts_rails_server = StartsRailsServer.new
      @finds_bin = FindsBin.new
    end

    def call(dir: Dir.pwd, port: ENV["RAILS_CYPRESS_PORT"], record_key: ENV["CYPRESS_RECORD_KEY"])
      @starts_rails_server.call(dir: dir, port: port)
      bin = @finds_bin.call(dir)

      cmd = %(CYPRESS_BASE_URL=http://#{Capybara.server_host}:#{Capybara.server_port} #{bin} run --project \"#{dir}\")

      if record_key
        cmd += " --record --key #{record_key}"
      end

      system(cmd)
    end
  end
end
