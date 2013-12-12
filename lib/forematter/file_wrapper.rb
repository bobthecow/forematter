# encoding: utf-8

module Forematter
  class FileWrapper
    extend Forwardable

    def initialize(filename)
      fail Forematter::UnexpectedValue, "File not found: #{filename}" unless File.file?(filename)
      @filename = filename
    end

    attr_reader :filename

    def_delegators :meta, :key?, :has_key?, :[], :[]=, :delete, :rename

    def to_s
      "#{meta.to_yaml}---\n#{content}"
    end

    def write
      File.open(filename, 'w+') { |f| f << to_s }
    end

    def content
      parse_file
      @content
    end

    protected

    def meta
      parse_file
      @meta
    end

    def parse_file
      return if @is_parsed

      data    = '--- {}'
      content = IO.read(@filename)
      if content =~ /\A(---\s*\n.*?\n?)^(?:(?:---|\.\.\.)\s*$\n?)/m
        data    = Regexp.last_match[1]
        content = $POSTMATCH
      end

      @meta      = Forematter::Frontmatter.new(data)
      @content   = content
      @is_parsed = true
    end
  end
end
