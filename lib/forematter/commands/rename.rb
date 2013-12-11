# encoding: utf-8

value_args  :one
aliases     :mv
summary     'rename a field'
description <<-EOS
Rename a frontmatter field in a set of files.
EOS

module Forematter::Commands
  class Rename < Forematter::CommandRunner
    def run
      files_with(field).each do |file|
        file.rename(field, value)
        file.write
      end
    end
  end
end

runner Forematter::Commands::Rename
