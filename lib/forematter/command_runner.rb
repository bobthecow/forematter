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
      @has_error = 1
    end

    def super_usage
      path = [command.supercommand]
      path.unshift(path[0].supercommand) until path[0].nil?
      path[1..-1].map { |c| c.name + ' ' }.join
    end

    def field
      partition
      fail Forematter::UsageError, 'Missing field name' unless @field
      @field
    end

    def value
      fail 'ARGS!' unless command.value_args == :one
      partition
      fail Forematter::UsageError, 'Missing argument' unless @value
      @value
    end

    def values
      fail 'ARGS!' unless command.value_args == :many
      partition
      fail Forematter::UsageError, 'Missing argument' if @values.empty?
      @values
    end

    def files
      partition
      fail Forematter::UsageError, 'No file(s) specified' if @files.empty?
      @files
    end

    def files_with(key)
      files.select { |f| f.key?(key) }
    end

    def partition
      return if @args_partitioned
      args = arguments.dup
      @field = args.shift
      @value = args.shift               if command.value_args == :one
      @values, args = guess_split(args) if command.value_args == :many
      @files = args.map { |f| wrap_file(f) }.compact
      @args_partitioned = true
    end

    def wrap_file(filename)
      Forematter::FileWrapper.new(filename)
    rescue Forematter::NoSuchFileError
      $stderr.puts "#{super_usage}#{command.name}: #{filename}: No such file".color(:red)
      @has_error = 1
      nil
    end

    def guess_split(args)
      if (i = args.index('--'))
        [args[0..i], args[i..-1]]
      else
        files = []
        files.unshift(args.pop) while !args.empty? && File.exist?(args.last)
        [args, files]
      end
    end
  end
end
