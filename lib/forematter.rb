# encoding: utf-8

# stdlib
require 'date'
require 'English'
require 'forwardable'
require 'yaml'
require 'json'

# third party
require 'cri'

# forematter
require 'forematter/version'
require 'forematter/core_ext'
require 'forematter/cri_ext'
require 'forematter/frontmatter'
require 'forematter/file_wrapper'
require 'forematter/command_runner'

module Forematter
  module Commands
  end

  class UsageException < Exception
  end

  class UnexpectedValue < Exception
  end

  class NoSuchFile < Exception
  end

  class << self
    attr_reader   :root_command
    # attr_accessor :verbose

    def run(args)
      # Remove the signal trap we set in the bin file.
      Signal.trap('INT', 'DEFAULT')
      setup
      root_command.run(args)
    end

    def add_command(cmd)
      root_command.add_command(cmd)
    end

    protected

    def setup
      root_cmd_filename = File.dirname(__FILE__) + '/forematter/commands/fore.rb'

      # Add help and root commands
      @root_command = load_command_at(root_cmd_filename)
      add_command(Cri::Command.new_basic_help)

      cmd_filenames.each do |filename|
        add_command(load_command_at(filename)) unless filename == root_cmd_filename
      end
    end

    def cmd_filenames
      Dir[File.dirname(__FILE__) + '/forematter/commands/*.rb']
    end

    def load_command_at(filename, command_name = nil)
      Cri::Command.define(File.read(filename), filename).modify do
        name command_name || File.basename(filename, '.rb')
        auto_usage
      end
    end
  end
end
