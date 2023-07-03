require_relative 'file.rb'
require_relative 'directory.rb'
require_relative 'utils.rb'
require_relative 'exceptions.rb'
require_relative 'authenticator.rb'
require_relative 'session.rb'
require 'io/console'

class Console
	attr_accessor :root_dir, :current_dir, :running

	def initialize(filename=nil)
		@filename = filename
		if @filename.nil?
			new_root  	
		else
			load_root
		end

		@current_dir = @root_dir              
		@running = true
		
		@logged_in = nil
		Authenticator.load
	end

	# Load root directory from file
	# If file is not found, create a new root directory, which will be persisted when user exits
	def load_root
		begin
			File.open(@filename, 'rb') do |file|
				@root_dir = Marshal.load(file.read)
			end
		rescue Errno::ENOENT
			new_root
		rescue TypeError
			puts "File type not recognized. Workspace won't be saved."
			new_root
			@filename = nil
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

	# Create root directory, which has no parent directory
	def new_root
		@root_dir = Directory.new('', nil, nil)
	end

	# Leave main loop and save root dir if necessary
	def exit
		@running = false
		Authenticator.save 
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

		new_file = MyFile.new(name, content, @current_dir, @logged_in.username)
		
		@current_dir.add(new_file)
	end

	# Create a new directory
	def create_folder(name)
		raise FileExistsError if @current_dir.get(name)
		
		new_folder = Directory.new(name, @current_dir, @logged_in.username)
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

	# Create a new user
	def create_user(username)
		password = IO::console.getpass "Enter password for #{username}: "

		Authenticator.new_user(username, password)
		puts "User #{username} successfully created."
	end

	# Log in as an existing user
	def login(username)
		password = IO::console.getpass "Enter password for #{username}: "

		@logged_in = Authenticator.authenticate_user(username, password)
		if @logged_in
			puts "Logged in successfully"
		else
			puts "Login information incorrect"
		end
	end


	# Main console loop for inputting commands
	def loop
		begin
			print "#{@logged_in.username}@" if @logged_in
			print "console:#{@current_dir.full_path}> "
			
			command = STDIN.gets.chomp      # Get user input and remove \n
			parts = command.split(" ")  		# Separate command into parts
		
			case parts[0]
			when "create_file"
				raise IncompleteCommandError, "missing file name" if parts[1].nil?
				raise UserNotAuthenticatedError unless @logged_in
				content = parts[2..] ? parts[2..].join(" ") : ""
				create_file(parts[1], content)
		
			when "create_folder"
				raise IncompleteCommandError, "missing folder name" if parts[1].nil?
				raise UserNotAuthenticatedError unless @logged_in
				create_folder(parts[1])
		
			when "show"
				raise IncompleteCommandError, "missing file name" if parts[1].nil?
				show_file(parts[1])
		
			when "cd"
				raise IncompleteCommandError, "missing path" if parts[1].nil?
				change_directory(parts[1])
		
			when "destroy"
				raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
				raise UserNotAuthenticatedError unless @logged_in
				delete(parts[1])
		
			when "ls"
				show_dir(parts[1])
		
			when "metadata"
				raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
				show_metadata(parts[1])
		
			when "help"
				puts get_command_list
		
			when "whereami"
				puts @current_dir.full_path

			when "create_user"
				raise IncompleteCommandError, "missing username" if parts[1].nil?
				create_user(parts[1])
			
			when "login"
				raise IncompleteCommandError, "missing username" if parts[1].nil?
				login(parts[1])

			when "logout"
				@logged_in = nil

			when "whoami"
				if @logged_in
					puts "Logged in as #{@logged_in.username} since #{@logged_in.start_time}"
				else
					puts "Not authenticated"
				end

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
		rescue UserAlreadyExistsError => e 
			puts "Cannot register #{e.message}: user already exists"
		rescue UserNotExistsError => e 
			puts "User #{e.message} doesn't exist"
		rescue UserNotAuthenticatedError => e   
			puts "You have to be logged in to perform that action."
		end
		
	end
end


