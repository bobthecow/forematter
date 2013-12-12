# encoding: utf-8

value_args  :many
aliases     :rm
summary     'remove values from a field'
description <<-EOS
Remove values from a frontmatter field in a set of files.

If the given frontmatter field is present on a file, but the value isn't a
string, `fore remove` will exit with an error.
EOS

module Forematter::Commands
  class Remove < Forematter::CommandRunner
    def run
      files_with(field).each do |file|
        old = file[field].to_ruby
        log_skip(file, "#{field} is not an array") && next unless old.is_a?(Array)

        # Continue unless old contains elements of values
        next if (old & values).empty?
        values.each { |v| file[field].delete(v) }

        file.write
      end
    end
  end
end

runner Forematter::Commands::Remove
