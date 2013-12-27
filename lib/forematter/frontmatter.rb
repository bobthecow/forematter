# encoding: utf-8

module Forematter
  class Frontmatter
    def initialize(input)
      init_stream(input)
    end

    def key?(key)
      data.children.each_index do |i|
        next unless i.even?
        return true if data.children[i].to_ruby == key
      end

      false
    end
    alias_method :has_key?, :key?

    def [](key)
      data.children.each_index do |i|
        next unless i.even?
        return data.children[i + 1] if data.children[i].to_ruby == key
      end
      nil
    end

    def []=(key, val)
      data.children.each_index do |i|
        next unless i.even?
        if data.children[i].to_ruby == key
          data.children[i + 1] = thunk(val, data.children[i + 1])
          return
        end
      end

      data.children << Psych::Nodes::Scalar.new(key)
      data.children << thunk(val)
    end

    def delete(key)
      data.children.each_index do |i|
        next unless i.even?
        if data.children[i].to_ruby == key
          val = data.children.delete_at(i + 1)
          data.children.delete_at(i)
          return val
        end
      end
    end

    def rename(key, new_key)
      data.children.each_index do |i|
        next unless i.even?
        if data.children[i].to_ruby == key
          data.children[i].value = new_key
          return
        end
      end
    end

    def to_yaml
      @stream.to_yaml
    end

    protected

    def thunk(val, old = nil)
      return val if val.is_a?(Psych::Nodes::Node)
      val = parse_yaml(val)
      if old.is_a?(Psych::Nodes::Sequence) && val.is_a?(Psych::Nodes::Sequence)
        old.children.replace(val.children)
        val = old
      end
      val
    end

    def parse_yaml(val)
      YAML.parse(YAML.dump(val)).children.first
    end

    attr_reader :data

    def init_stream(input)
      doc = YAML.parse_stream(input).children.first
      @data = doc.children.first
      @stream = YAML.parse_stream('')
      @stream.children << doc
    end
  end
end
