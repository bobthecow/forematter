# encoding: utf-8

value_args  :one
value_name  'pattern'
summary     'search for values in a field'
description <<-EOS
Search for values for a given frontmatter field in a set of files.

The search pattern may be a string or regular expression, e.g. `/foo\.bar/`.
EOS

flag :i,  :'ignore-case',        'perform case insensitive matching'
flag :l,  :'files-with-matches', 'only list the names of files with matches'
flag nil, :print0,               'list file names followed by an ASCII NUL character (for use with `xargs -0`)'

module Forematter::Commands
  class Search < Forematter::CommandRunner
    def run
      files_with(field).sort_by(&:filename).each do |file|
        field_val = file[field].to_ruby
        if field_val.is_a? Array
          next unless field_val.any? { |v| pattern =~ v }
        else
          next unless pattern =~ field_val
        end
        write(file.filename, field_val)
      end
    end

    protected

    def write(filename, val)
      if options[:print0]
        print "#{filename}\0"
      elsif options[:'files-with-matches']
        puts filename
      else
        puts "#{filename}: #{val.to_json}"
      end
    end

    def pattern
      @pattern ||= parse_pattern
    end

    def parse_pattern
      opts = options[:'ignore-case'] ? Regexp::IGNORECASE : 0

      if %r{^/(.*)/([im]{0,2})$} =~ value
        val = Regexp.last_match[1]
        opts |= Regexp::IGNORECASE if Regexp.last_match[2].include? 'i'
        opts |= Regexp::MULTILINE  if Regexp.last_match[2].include? 'm'
      else
        val = Regexp.escape(value)
      end

      Regexp.new(val, opts)
    end
  end
end

runner Forematter::Commands::Search
