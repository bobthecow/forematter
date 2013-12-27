# encoding: utf-8

usage       'cleanup [options] <field> <file> [<file>...]'
summary     'clean up a field'
description <<-EOS
Normalize values in a frontmatter field in a set of files.

If the given frontmatter field is present on a file, but the value isn't a
string, `fore cleanup --sort` will exit with an error.
EOS

flag nil, :downcase,   'change to lower case'
flag nil, :capitalize, 'change to sentence case'
flag nil, :titlecase,  'change to title case'
flag nil, :sort,       'sort field values'
# flag nil, :translit,   'transliterate values'
flag nil, :trim,       'trim whitespace'
flag nil, :url,        'sluggify'

module Forematter::Commands
  class Cleanup < Forematter::CommandRunner
    include Forematter::Arguments::FieldFiles

    def run
      require 'stringex_lite'
      require 'titleize'

      files_with(field).each do |file|
        cleanup_file(file)
      end
    end

    protected

    def cleanup_file(file)
      old = file[field].to_ruby
      val = cleanup(old)
      return if val == old
      file[field] = val
      file.write
    rescue Forematter::UnexpectedValueError => e
      log_skip(file, e.message)
    end

    CLEANUP_MAP = {
      downcase:   :downcase,
      capitalize: :capitalize,
      titlecase:  :titleize,
      # translit:   :translit,
      trim:       :strip,
      url:        :to_url,
    }

    def cleanup(val)
      val = val.dup
      return cleanup_array(val) if val.is_a?(Array)
      fail Forematter::UnexpectedValueError, "#{field} is not an array" if options[:sort]
      options.keys.each do |option|
        val = val.method(CLEANUP_MAP[option]).call if CLEANUP_MAP.key?(option) && options[option]
      end
      val
    end

    def cleanup_array(val)
      options.keys.each do |option|
        val.map!(&CLEANUP_MAP[option]) if CLEANUP_MAP.key?(option) && options[option]
      end
      val.sort_by!(&:downcase) if options[:sort]
      val
    end
  end
end

runner Forematter::Commands::Cleanup
