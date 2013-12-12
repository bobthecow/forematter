# encoding: utf-8

value_args  :many
summary     'combine multiple values for a field'
description <<-EOS
Combine multiple values for a frontmatter field in a set of files.

If the given frontmatter field is present on a file, but the value isn't a
string, `fore merge` will exit with an error.
EOS

module Forematter::Commands
  class Merge < Forematter::CommandRunner
    def run
      dups      = values.dup
      canonical = dups.shift

      files_with(field).each do |file|
        old = file[field].to_ruby
        log_skip(file, "#{field} is not an array") && next unless old.is_a?(Array)

        # Continue unless unless field had one of the values to remove
        next if (old & dups).empty?
        dups.each { |v| file[field].delete(v) }

        # Save the original canonical for later
        file[field] << canonical unless file[field].include?(canonical)
        file.write
      end
    end
  end
end

runner Forematter::Commands::Merge
