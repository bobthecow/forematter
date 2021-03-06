# encoding: utf-8

usage       'add [options] <field> <value> [<value>...] <file> [<file>...]'
summary     'add values to a field'
description <<-EOS
Add values to a frontmatter field in to a set of files.

By default, values will only be added if they don't already exist in a set. This
can be overridden with `--allow-dupes`.

If the specified frontmatter field is present on a file, but the value isn't a
YAML sequence (array), `fore add` will exit with an error.
EOS

flag nil, :'allow-dupes', 'allow duplicate values'

module Forematter::Commands
  class Add < Forematter::CommandRunner
    include Forematter::Arguments::FieldValuesFiles

    def run
      files.each do |file|
        old = file.key?(field) ? file[field].to_ruby : []
        log_skip(file, "#{field} is not an array, unable to add") && next unless old.is_a?(Array)
        add = options[:'allow-dupes'] ? values : values.select { |v| !old.include?(v) }
        next if add.empty?
        add.each { |v| old << v }
        file[field] = old
        file.write
      end
    end
  end
end

runner Forematter::Commands::Add
