require_relative 'file.rb'
require_relative 'directory.rb'
require_relative 'utils.rb'
require_relative 'exceptions.rb'

# Write a welcome message
puts "Console app v0.1"
puts "Use 'exit' to close the app. Use 'help' to get a list of all available commands."
puts ""

root_dir = Directory.new('', nil)  # Create root directory, which has no parent directory
current_dir = root_dir              # Set current directory as root

# Main program loop
loop do 
begin
    print current_dir.full_path+"> "
    
    command = gets.chomp        # Get user input and remove \n
    parts = command.split(" ")  # Separate command into parts

    case parts[0]
    when "create_file"
        raise IncompleteCommandError, "missing file name" if !parts[1]
        raise FileExistsError if current_dir.get_element(parts[1])
			
		if parts[2..]
			# Create file with specified content
			new_file = File.new(parts[1], parts[2..].join(" "), current_dir)
		else
			# Create empty file 
			new_file = File.new(parts[1], "", current_dir)
		end
		current_dir.add_file(new_file)

    when "create_folder"
		raise IncompleteCommandError, "missing folder name" if !parts[1]
		raise FileExistsError if current_dir.get_element(parts[1])

		new_folder = Directory.new(parts[1], current_dir)
		current_dir.add_folder(new_folder)

    when "show"
		raise IncompleteCommandError, "missing file name" if !parts[1]

		file = current_dir.get_file(parts[1])
		if file
			puts file.content
		else
			raise FileNotFoundError, parts[1]
		end

    when "cd"
        raise IncompleteCommandError, "missing folder name" if !parts[1]

		folder = current_dir.get_folder(parts[1])
		if folder
			current_dir = folder
		else
			raise FolderNotFoundError, parts[1]
		end

    when "destroy"
		raise IncompleteCommandError, "missing file/folder name" if !parts[1]
		
		print "Are you sure you want to delete #{parts[1]}? (Y to continue): "
		answer = gets.chomp.downcase
		if (answer == "y")
			if current_dir.find_and_delete(parts[1])
				puts "#{parts[1]} deleted."
			else
				raise FileNotFoundError, parts[1]
			end
		else
			puts "Aborted."
		end

	when "rename"
		raise IncompleteCommandError, "missing file/folder name" if !parts[1]

		f = current_dir.get_element(parts[1])
		raise FileNotFoundError, parts[1] if f.nil?

		print "New name: "
		new_name = gets.chomp
		f.rename(new_name)

    when "ls"
        puts current_dir.show

    when "metadata"
		raise IncompleteCommandError, "missing file/folder name" if !parts[1]

		f = current_dir.get_element(parts[1])
        raise FileNotFoundError, parts[1] if f.nil?
        
		puts f.metadata

    when "help"
        puts get_command_list

    when "whereami"
        puts current_dir.full_path
            
    when "exit"
        break

    else
        puts "Command not recognized. Use 'help' to get a list of the available commands."
    end
	
rescue IncompleteCommandError => e 
	puts "Incomplete command: #{e.message}"
rescue FileExistsError => e
    puts "'#{parts[1]}' already exists in the current directory."
rescue FileNotFoundError => e 
	puts "File not found: #{e.message}"
rescue FolderNotFoundError => e 
	puts "Folder not found: #{e.message}"
end

end
