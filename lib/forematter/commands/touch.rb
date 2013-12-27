# encoding: utf-8

usage   'touch [options] <field> <file> [<file>...]'
summary 'update a field timestamp'

i = "\xC2\xA0" * 4
description <<-EOS
Update a frontmatter field timestamp for a set of files.

The new defaults to the current time, but may be overridden by passing
`--time`.

By default, an ISO-8601 string is used. Alternate formats may be specified:

--format iso8601

#{i}ISO-8601 date format, e.g. 2001-02-03T04:05:06+07:00 (default)

--format date

#{i}A YAML date literal.

--format db

#{i}ANSI SQL date format, e.g. 2001-02-03 04:05:06

--format '%Y-%m-%d'

#{i}Or any valid strftime format string
EOS

required :t, :time,   'new timestamp value (default: now)'
required :f, :format, 'timestamp format (default: iso8601)'

module Forematter::Commands
  class Touch < Forematter::CommandRunner
    include Forematter::Arguments::FieldFiles

    def run
      files_with(field).each do |file|
        file[field] = now
        file.write
      end
    end

    protected

    def now
      @now ||= format_now
    end

    def format_now
      format = options[:format] || 'iso8601'
      now    = options.key?(:time) ? Time.new(options[:time]) : Time.now

      case format
      when 'date'    then now
      when 'iso8601' then now.to_datetime.iso8601
      when 'db'      then now.strftime('%Y-%m-%d %H:%M:%S')
      else
        now.strftime(format)
      end
    end
  end
end

runner Forematter::Commands::Touch
