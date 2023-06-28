require_relative 'file.rb'
require_relative 'directory.rb'
require_relative 'utils.rb'

# Write a welcome message
puts "Console app v0.1"
puts "Write 'exit' to close the app"
puts ""

root_dir = Directory.new('', nil)  # Create root directory, which has no parent directory
current_dir = root_dir              # Set current directory as root

# Main program loop
loop do 
    print current_dir.full_path+"> "
    
    command = gets.chomp        # Get user input and remove \n
    parts = command.split(" ")  # Separate command into parts

    case parts[0]
    when "create_file"
        if parts[1]
            if !current_dir.get_element(parts[1])
                if parts[2..]
                    # Create file with specified content
                    new_file = File.new(parts[1], parts[2..].join(" "), current_dir)
                else
                    # Create empty file 
                    new_file = File.new(parts[1], "", current_dir)
                end
                current_dir.add_file(new_file)
            else
                puts "'#{parts[1]}' already exists in the current directory."
            end
        else
            puts "You have to specify a file name"
        end

    when "create_folder"
        if parts[1]
            if !current_dir.get_element(parts[1])
                new_folder = Directory.new(parts[1], current_dir)
                current_dir.add_folder(new_folder)
            else
                puts "'#{parts[1]}' already exists in the current directory."
            end
        else
            puts "You have to specify a folder name"
        end

    when "show"
        if parts[1]
            file = current_dir.get_file(parts[1])
            if file
                puts file.content
            else
                puts "File #{parts[1]} not found."
            end
        else
            puts "You have to specify a file name"
        end

    when "cd"
        if parts[1]
            folder = current_dir.get_folder(parts[1])
            if folder
                current_dir = folder
            else
                puts "Folder #{parts[1]} not found."
            end
        else
            puts "You have to specify a folder name"
        end

    when "destroy"
        if parts[1]
            print "Are you sure you want to delete #{parts[1]}? (Y to continue): "
            answer = gets.chomp.downcase
            if (answer == "y")
                if current_dir.find_and_delete(parts[1])
                    puts "#{parts[1]} deleted."
                else
                    puts "#{parts[1]} not found."
                end
            else
                puts "Aborted."
            end
        else
            puts "You have to specify a name"
        end

    when "ls"
        puts current_dir.show

    when "metadata"
        if parts[1]
            f = current_dir.get_element(parts[1])
            if f
                puts f.metadata
            else
                puts "File or directory not found."
            end
        end

    when "help"
        puts get_command_list

    when "whereami"
        puts current_dir.full_path
            
    when "exit"
        break

    else
        puts "Command not recognized. Use 'help' to get a list of the available commands."
    end
end
