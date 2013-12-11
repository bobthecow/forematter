# encoding: utf-8

fail 'Forematter requires Psych' unless defined?(Psych)

# class String
#   def translit
#     convert_smart_punctuation.
#       convert_accented_html_entities.
#       convert_vulgar_fractions.
#       convert_miscellaneous_html_entities.
#       convert_miscellaneous_characters.
#       to_ascii.
#       convert_miscellaneous_characters.
#       collapse
#   end
# end

module Psych::Nodes
  class Sequence
    def include?(val)
      children.any? { |c| c.to_ruby == val }
    end

    def delete(val)
      return unless include?(val)
      children.each_index do |i|
        return children.delete_at(i) if children[i].to_ruby == val
      end
    end

    def [](index)
      fail "Unexpected index: #{index}" unless index.is_a? Integer
      children[index]
    end

    def []=(index = nil, val)
      return push(val) if index.nil?
      fail "Unexpected index: #{index}" unless index.is_a? Integer
      children[index] = YAML.parse(YAML.dump(val)).children.first
    end

    def push(val)
      children.push(YAML.parse(YAML.dump(val)).children.first)
    end
    alias_method :<<, :push
  end
end
