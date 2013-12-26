# encoding: utf-8

module Forematter
  class CommandRunner < ::Cri::CommandRunner
    def call
      run
      exit 1 if @has_error
    rescue Forematter::AmbiguousArgumentError
      $stderr.puts "Ambiguous arguments. Use '--' to separate values from files, like this:".red
      $stderr.puts "'#{super_usage}#{command.name} <field> <value> [<value>...] -- <file> [<file>...]'".red
      exit 1
    rescue Forematter::UsageError
      $stderr.puts "usage: #{super_usage}#{command.usage}".red
      exit 1
    end

    protected

    def log_skip(file, msg)
      filename = file.respond_to?(:filename) ? file.filename : file
      $stderr.puts "#{super_usage}#{command.name}: #{filename}: #{msg}".red
      @has_error = true
    end

    def super_usage
      path = [command.supercommand]
      path.unshift(path[0].supercommand) until path[0].nil?
      path[1..-1].map { |c| c.name + ' ' }.join
    end
  end
end
