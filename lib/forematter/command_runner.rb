# encoding: utf-8

module Forematter
  class CommandRunner < ::Cri::CommandRunner
    def call
      run
      exit 1 if @has_error
    rescue Forematter::UsageError
      $stderr.puts "usage: #{super_usage}#{command.usage}".red
      exit 1
    end

    protected

    def log_skip(file, msg)
      $stderr.puts "#{super_usage}#{command.name}: #{file.filename}: #{msg}".red
      @has_error = true
    end

    def super_usage
      path = [command.supercommand]
      path.unshift(path[0].supercommand) until path[0].nil?
      path[1..-1].map { |c| c.name + ' ' }.join
    end
  end
end
