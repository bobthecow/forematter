# encoding: utf-8

no_field_arg
summary     'list known fields'
description <<-EOS
List all known fields in a set of files.
EOS

module Forematter::Commands
  class Fields < Forematter::CommandRunner
    def run
      fields.each do |field|
        puts field
      end
    end

    protected

    def fields
      files.map { |file| file.keys }.flatten.map(&:to_sym).uniq.sort
    end
  end
end

runner Forematter::Commands::Fields
