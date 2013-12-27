# encoding: utf-8

module Cri
  class Command
    attr_accessor :value_args
    attr_accessor :value_name
    attr_accessor :no_field_arg
  end

  class CommandDSL
    def value_args(count)
      @command.value_args = count
    end

    def value_name(name)
      @command.value_name = name
    end

    def no_field_arg
      @command.no_field_arg = true
    end

    NBSP = "\xC2\xA0"

    def auto_usage
      name  = @command.name
      value = @command.value_name || 'value'
      field = @command.no_field_arg ? '' : 'field '
      case @command.value_args
      when :none
        usage "#{name} [options] #{field}file [file#{NBSP}...]"
      when :one
        usage "#{name} [options] #{field}#{value} file [file#{NBSP}...]"
      when :many
        usage "#{name} [options] #{field}#{value} [#{value}#{NBSP}...] file [file#{NBSP}...]"
      else
        usage "#{name} [options] #{field}file [file#{NBSP}...]"
      end
    end
  end
end
