# encoding: utf-8

module Forematter::Arguments
  module FieldFiles
    include Forematter::Arguments::Files

    def field
      @field ||= arguments.first
      fail Forematter::UsageError, 'Missing field name' unless @field
      @field
    end

    protected

    def partition
      @filenames ||= arguments[1..-1] || []
    end
  end
end
