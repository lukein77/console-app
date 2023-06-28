require 'file'

# Main program loop
puts "Console app v0.1"
puts "Write 'exit' to close the app"
puts ""

loop do 
    print "> "
    
    command = gets.chomp
    parts = command.split(" ")  # Separate command into parts

    case parts[0]
    when "print"
        if parts[1]
            puts "The user prints "+parts[1..].join(" ")
        else
            puts "The user didn't specify anything to print"
        end
    when "exit"
        break
    else
        puts "Command not recognized."
    end
end
