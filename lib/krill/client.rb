# typed: false
# frozen_string_literal: true

require 'socket'

module Krill

  class Client

    def initialize
      @hostname = Bioturk::Application.config.krill_hostname
      @port = Bioturk::Application.config.krill_port
    end

    def open
      @socket = TCPSocket.open(@hostname, @port)
    rescue StandardError
      raise "Could not connect to Krill server #{@hostname}:#{@port}. It is probably not running."
    end

    def close
      @socket.close
    end

    def send(x)
      open

      msg = x.to_json
      @socket.puts msg

      answer = ''
      while (line = @socket.gets)
        answer += line.chop
      end

      close

      JSON.parse(answer, symbolize_names: true)
    end

    def start(jid)
      send(operation: 'start', jid: jid)
    end

    def jobs
      send(operation: 'jobs')
    end

    def abort(jid)
      send(operation: 'abort', jid: jid)
    end

    def continue(jid)
      send(operation: 'continue', jid: jid)
    end

    def kill_zombies
      send(operation: 'kill zombies')
    end

  end

end
