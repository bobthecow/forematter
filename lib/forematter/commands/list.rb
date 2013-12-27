# encoding: utf-8

usage       'list <field> <file> [<file>...]'
aliases     :ls
summary     'list values for a field'
description <<-EOS
List the values for a given frontmatter field in a set of files.
EOS

module Forematter::Commands
  class List < Forematter::CommandRunner
    include Forematter::Arguments::FieldFiles

    def run
      puts tags.uniq.compact.map(&:to_s).sort_by(&:downcase).join("\n")
    end

    protected

    def tags
      files_with(field).map { |file| file[field].to_ruby }.flatten
    end
  end
end

runner Forematter::Commands::List
