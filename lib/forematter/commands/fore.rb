# encoding: utf-8

usage   'fore <command> [options] [arguments]'
summary 'Forematter, the frontmatter-aware friend for your static site'

flag :h, :help, 'show the help message and quit' do |value, cmd|
  puts cmd.help
  exit 0
end

flag :v, :version, 'show version' do
  puts "fore version #{Forematter::VERSION}"
  exit 0
end

run do |opts, args, cmd|
  puts cmd.help
end
