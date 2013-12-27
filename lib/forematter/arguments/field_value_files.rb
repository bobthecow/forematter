# encoding: utf-8

module Forematter::Arguments
  module FieldValueFiles
    include Forematter::Arguments::FieldFiles

    def value
      @value ||= arguments[1]
      fail Forematter::UsageError, 'Missing argument' unless @value
      @value
    end

    protected

    def partition
      @filenames ||= arguments[2..-1] || []
    end
  end
end
