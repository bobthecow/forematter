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
        @values, @filenames = guess_split
        true
      end
    end

    def guess_split
      # TODO: use arguments.raw once cri 2.5.0 ships.
      args = arguments[1..-1] || []
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
