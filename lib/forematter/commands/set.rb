# encoding: utf-8

value_args  :one
summary     'set a field value'
description <<-EOS
Set a frontmatter field value on a set of files.
EOS

module Forematter::Commands
  class Set < Forematter::CommandRunner
    def run
      files.each do |file|
        file[field] = value
        file.write
      end
    end

    protected

    def value
      val = super
      YAML.load(val)
    rescue Psych::SyntaxError
      val
    end
  end
end

runner Forematter::Commands::Set
