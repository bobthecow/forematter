# encoding: utf-8

value_args  :none
summary     'remove a field'
description <<-EOS
Remove a frontmatter field from a set of files.
EOS

module Forematter::Commands
  class Unset < Forematter::CommandRunner
    def run
      files_with(field).each do |file|
        file.delete(field)
        file.write
      end
    end
  end
end

runner Forematter::Commands::Unset
