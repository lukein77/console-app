require_relative 'file.rb'
require_relative 'directory.rb'

# Main program loop
puts "Console app v0.1"
puts "Write 'exit' to close the app"
puts ""

files = []

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

    when "create_file"
        if parts[1]
            if parts[2..]
                # Create file with content
                new_file = File.new(parts[1], parts[2..].join(" "))
            else
                # Create empty file
                new_file = File.new(parts[1], "")
            end
            files.push(new_file)
        else
            puts "You have to specify a file name"
        end

    when "create_folder"
        if parts[1]
            new_file = Directory.new(parts[1], "nobody")
            files.push(new_file)
        else
            puts "You have to specify a folder name"
        end

    when "show"
        if !files.empty?
            puts files[0].show
        end

    when "metadata"
        if parts[1]
            puts files[0].metadata
        end
            
    when "exit"
        break

    else
        puts "Command not recognized."
    end
end
