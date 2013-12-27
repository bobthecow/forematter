# encoding: utf-8

usage       'rename <field> <new_field> <file> [<file>...]'
aliases     :mv
summary     'rename a field'
description <<-EOS
Rename a frontmatter field in a set of files.
EOS

module Forematter::Commands
  class Rename < Forematter::CommandRunner
    include Forematter::Arguments::FieldValueFiles

    def run
      files_with(field).each do |file|
        file.rename(field, value)
        file.write
      end
    end
  end
end

runner Forematter::Commands::Rename
