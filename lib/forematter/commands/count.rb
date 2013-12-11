# encoding: utf-8

value_args  :none
summary     'count values in a field'
description <<-EOS
Count the number of times each value of a given field appears in a set of files.
EOS

module Forematter::Commands
  class Count < Forematter::CommandRunner
    def run
      counts = tags.reduce({}) { |a, e| a.merge(e => (a[e] || 0) + 1) }
      fmt    = format(counts)

      counts.sort_by { |tag, count| count }.each do |tag, count|
        puts sprintf(fmt, count, tag)
      end
    end

    protected

    def tags
      files_with(field).map { |file| file[field].to_ruby }.flatten.map(&:to_sym)
    end

    def format(counts)
      "%#{counts.values.max.to_s.length}d %s"
    end
  end
end

runner Forematter::Commands::Count
