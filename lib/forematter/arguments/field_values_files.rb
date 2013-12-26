# encoding: utf-8

module Forematter::Arguments
  module FieldValuesFiles
    include Forematter::Arguments::FieldFiles

    def values
      partition
      fail Forematter::UsageError, 'Missing argument' if @values.empty?
      @values
    end

    protected

    def partition
      @args_partitioned ||= begin
        @values, @filenames = split_args
        true
      end
    end

    def split_args
      args = arguments.raw[1..-1] || []
      split_on_divider(args) || guess_split(args)
    end

    def split_on_divider(args)
      if (i = args.index('--'))
        files = args[(i + 1)..-1]
        fail Forematter::AmbiguousArgumentError if files.include?('--') # There can be only one
        [args[0..i], files]
      end
    end

    def guess_split(args)
      files = []
      files.unshift(args.pop) while args.length > 1 && File.file?(args.last)
      fail Forematter::AmbiguousArgumentError if args.any? { |v| File.file?(v) }
      [args, files]
    end
  end
end
