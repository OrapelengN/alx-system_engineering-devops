#!/usr/bin/env ruby

# Read input from command line arguments
log_entry = ARGV[0]

# Define a regular expression to match the required fields
regex = /\[from:(?<from>[^\]]+)\] \[to:(?<to>[^\]]+)\] \[flags:(?<flags>[^\]]+)\]/

# Match the log entry against the regex
match_data = regex.match(log_entry)

# If a match is found, extract the values
if match_data
  sender = match_data[:from]
  receiver = match_data[:to]
  flags = match_data[:flags]

  # Output the result in the required format
  puts "#{sender},#{receiver},#{flags}"
end
