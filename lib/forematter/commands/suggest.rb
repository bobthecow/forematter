# encoding: utf-8

value_args  :none
summary     'suggest values for a field'
description <<-EOS
Suggest values for a given frontmatter field based on other files in a set.
EOS

flag nil, :override, 'Override existing values'

module Forematter::Commands
  class Suggest < Forematter::CommandRunner
    def run
      load_classifier

      # Seed LSI index
      files_with(field).each { |file| seed_index(file) }

      # This takes days:
      puts 'Building index... eesh'
      lsi.build_index
      puts "And we're done!"

      files.each { |file| get_recs(file) }
    end

    protected

    def load_classifier
      require 'classifier'
    rescue LoadError
      $stderr.puts 'Install "classifier" gem to generate suggestions'
      exit 1
    end

    def lsi
      @lsi ||= Classifier::LSI.new(auto_rebuild: false)
    end

    def seed_index(file)
      return unless file[:meta].key?(field)
      lsi.add_item file[:file], *file[:meta][field].to_ruby { |i| file[:content] }
    end

    def get_recs(file)
      return if file[:meta].key?(field) unless options[:override]

      # TODO: something here :)
    end
  end
end

runner Forematter::Commands::Suggest
