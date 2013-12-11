# encoding: utf-8

module Cri
  class Command
    attr_accessor :value_args
    attr_accessor :value_name
  end

  class CommandDSL
    def value_args(count)
      @command.value_args = count
    end

    def value_name(name)
      @command.value_name = name
    end

    NBSP = "\xC2\xA0"

    def auto_usage
      name  = @command.name
      value = @command.value_name || 'value'
      case @command.value_args
      when :none
        usage "#{name} [options] field file [file#{NBSP}...]"
      when :one
        usage "#{name} [options] field #{value} file [file#{NBSP}...]"
      when :many
        usage "#{name} [options] field #{value} [#{value}#{NBSP}...] file [file#{NBSP}...]"
      end
    end
  end
end
