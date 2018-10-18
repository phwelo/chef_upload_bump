#!/usr/bin/ruby

# Chef Upload Bump

require 'io/console'

def arg_logic
  ARGV[0] || parse_cbname
end

# This is only going to extract the name if its first instance of name
# because that if statement for some reason gets shit from the middle
# of a line, so if "dirname" is in there it's matching. DIY for later
def parse_cbname
  file = 'metadata.rb'
  verify_file("./#{file}")
  IO.readlines("./#{file}", 'r').each do |line|
    # checks the first 6 characters of each line for 'name{space}{single quote}'
    if line[0..5] == 'name \''
      # gets the name from returned string and returns that as string
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
  end
end

cookbook = arg_logic
# Main
`knife spork bump #{cookbook}`
`knife cookbook upload #{cookbook}`
