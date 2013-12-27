# encoding: utf-8

module Forematter::Arguments
  module Files
    def files
      partition
      @files ||= @filenames.map { |f| wrap_file(f) }.compact
      fail Forematter::UsageError, 'No file(s) specified' if @files.empty?
      @files
    end

    def files_with(key)
      files.select { |f| f.key?(key) }
    end

    protected

    def partition
      @filenames ||= arguments
    end

    def wrap_file(filename)
      Forematter::FileWrapper.new(filename)
    rescue Forematter::NoSuchFileError
      $stderr.puts "#{super_usage}#{command.name}: #{filename}: No such file".color(:red)
      @has_error = true
      nil
    end
  end
end
