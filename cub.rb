#!/usr/bin/ruby

# Chef Upload Bump

def arg_logic
  ARGV[0] || parse_cbname
end

# DIY - figure out why this seems to match things that don't start with name...
def parse_cbname
  file = 'metadata.rb'
  verify_file("./#{file}")
  metadata = File.readlines "./#{file}"
  metadata.each do |line|
    if line.start_with?('name')
      return line.match(/(["'])(?:(?=(\\?))\2.)*?\1/).to_s.delete('\'')
    end
  end
end

# Check if the file (metadata) exists
def verify_file(filename)
  if File.file?("./#{filename}")
    true
  else
    puts 'Usage: / ruby cub.rb cookbookname'
    exit
  end
end

cookbook = arg_logic
# Main
system("knife spork bump #{cookbook}")
system("knife cookbook upload #{cookbook}")
