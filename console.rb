require_relative 'file.rb'
require_relative 'directory.rb'
require_relative 'utils.rb'
require_relative 'exceptions.rb'

class Console
	attr_accessor :root_dir, :current_dir, :running

	def initialize(filename=nil)
		@filename = filename
		if @filename.nil?
			@root_dir = Directory.new('', nil)  	# Create root directory, which has no parent directory
		else
			load_root
		end

		@current_dir = @root_dir              # Set current directory as root
		@running = true
	end

	# Load root directory from file
	# If file is not found, create a new root directory, which will be persisted when user exits
	def load_root
		begin
			File.open(@filename, 'rb') do |file|
				@root_dir = Marshal.load(file.read)
			end
		rescue Errno::ENOENT
			@root_dir = Directory.new('', nil)
		end
	end

	# Save root directory to file
	# This method is only called if a filename was inputted
	def save_root
		File.open(@filename, 'wb') do |file|
			file.write(Marshal.dump(@root_dir))
		end
		puts "Saved workspace to #{@filename}"
	end

	# Leave main loop and save root dir if necessary
	def exit
		@running = false
		save_root if @filename		# if user provided a file for persistence, save the directory
	end
	
	# Message displayed on startup
	def welcome_message
		puts "Console app v0.1"
		puts "Use 'exit' to close the app. Use 'help' to get a list of all available commands."
		puts ""
	end

	# Differentiate between relative and absolute path and call the appropiate method
	def get_path(path)
		return nil if path.nil? || path.empty?
		
		if path[0] == "/"
			return root_dir.get_path(path[1..])
		else
			return @current_dir.get_path(path)
		end
	end

	# Create file with optional content (content should be a string)
	def create_file(name, content="")
		raise FileExistsError if @current_dir.get(name)

		new_file = MyFile.new(name, content, @current_dir)
		
		@current_dir.add(new_file)
	end

	# Create a new directory
	def create_folder(name)
		raise FileExistsError if @current_dir.get(name)
		
		new_folder = Directory.new(name, @current_dir)
		@current_dir.add(new_folder)
	end

	# Show the contents of a file
	# If name is a directory, shows the directory's content
	def show_file(name)
		file = @current_dir.get(name)
		if file
			puts file.show
		else
			raise FileNotFoundError, name
		end
	end

	# Changes the current directory
	def change_directory(path)
		dir = get_path(path)
		raise PathNotFoundError, path if !dir

		raise IsNotDirectoryError, path unless dir.is_a? Directory
		@current_dir = dir
	end

	# Deletes a file or folder. First prompts the user for confirmation
	def delete(name)
		print "Are you sure you want to delete #{name}? (Y to continue): "
		answer = STDIN.gets.chomp.downcase
		if (answer == "y")
			if @current_dir.find_and_delete(name)
				puts "#{name} deleted."
			else
				raise FileNotFoundError, name
			end
		else
			puts "Aborted."
		end
	end

	# Show the content of the current directory or of the path provided
	def show_dir(path=nil)
		if !path
			puts @current_dir.show
		else
			dir = get_path(path)
			raise PathNotFoundError, path if !dir
			puts dir.show
		end
	end

	# Show a file/folder's metadata
	def show_metadata(name)

		f = @current_dir.get(name)
		raise FileNotFoundError, name if f.nil?
		
		puts f.metadata
	end

	# Main console loop for inputting commands
	def loop
		begin
			print @current_dir.full_path+"> "
			
			command = STDIN.gets.chomp        # Get user input and remove \n
			parts = command.split(" ")  # Separate command into parts
		
			case parts[0]
			when "create_file"
				raise IncompleteCommandError, "missing file name" if parts[1].nil?
				content = parts[2..] ? parts[2..].join(" ") : ""
				create_file(parts[1], content)
		
			when "create_folder"
				raise IncompleteCommandError, "missing folder name" if parts[1].nil?
				create_folder(parts[1])
		
			when "show"
				raise IncompleteCommandError, "missing file name" if parts[1].nil?
				show_file(parts[1])
		
			when "cd"
				raise IncompleteCommandError, "missing path" if parts[1].nil?
				change_directory(parts[1])
		
			when "destroy"
				raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
				delete(parts[1])
		
			# when "rename"
			# 	raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
			# 	raise IncompleteCommandError, "missing new name" if parts[2].nil?
		
			# 	raise FileExistsError, parts[2] unless @current_dir.get(parts[2]).nil?
		
			# 	f = @current_dir.get(parts[1])
			# 	raise FileNotFoundError, parts[1] if f.nil?
		
			# 	f.rename(parts[2])
		
			when "ls"
				show_dir(parts[1])
		
			when "metadata"
				raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
				show_metadata(parts[1])
		
			when "help"
				puts get_command_list
		
			when "whereami"
				puts @current_dir.full_path
					
			when "exit"
				self.exit
		
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
		rescue PathNotFoundError => e 
			puts "Path not found: #{e.message}"
		rescue IsNotDirectoryError => e 
			puts "Error: #{e.message} is not a directory"
		end
		
	end
end


