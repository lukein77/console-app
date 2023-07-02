require_relative 'console.rb'

console = Console.new
console.welcome_message
while console.running
	console.loop
end