
require 'optparse'
require_relative 'console.rb'


options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: main.rb [options] [filename]"

  opts.on("-p", "--persisted", "Enable persistence") do
    options[:persisted] = true
  end

end.parse!

if options[:persisted]
    filename = ARGV[0]
    if filename.nil?
        puts "You have to provide a file name"
        exit
    end
    console = Console.new(filename)
else
    console = Console.new
end

console.welcome_message
while console.running
	console.loop
end