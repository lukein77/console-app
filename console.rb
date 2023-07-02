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
			# User provided a file name for persistence
			load
		end

		@current_dir = @root_dir              # Set current directory as root
		@running = true
	end

	def load
		# Load root_dir from file
		# If file is not found, create a new root directory
		begin
			File.open(@filename, 'rb') do |file|
				@root_dir = Marshal.load(file.read)
			end
		rescue Errno::ENOENT
			@root_dir = Directory.new('', nil)
		end
	end

	def save
		File.open(@filename, 'wb') do |file|
			file.write(Marshal.dump(@root_dir))
		end
		puts "Saved workspace to #{@filename}"
	end

	def exit
		@running = false
		save if @filename
	end
	
	def welcome_message
		# Write a welcome message
		puts "Console app v0.1"
		puts "Use 'exit' to close the app. Use 'help' to get a list of all available commands."
		puts ""
	end

	def get_path(path)
		return nil if path.nil? || path.empty?
		
		if path[0] == "/"
			return root_dir.get_path(path[1..])
		else
			return @current_dir.get_path(path)
		end
	end



	def loop
		begin
			print @current_dir.full_path+"> "
			
			command = STDIN.gets.chomp        # Get user input and remove \n
			parts = command.split(" ")  # Separate command into parts
		
			case parts[0]
			when "create_file"
				raise IncompleteCommandError, "missing file name" if parts[1].nil?
				raise FileExistsError if @current_dir.get(parts[1])
					
				if parts[2..]
					# Create file with specified content
					new_file = MyFile.new(parts[1], parts[2..].join(" "), @current_dir)
				else
					# Create empty file 
					new_file = MyFile.new(parts[1], "", @current_dir)
				end
				@current_dir.add(new_file)
		
			when "create_folder"
				raise IncompleteCommandError, "missing folder name" if parts[1].nil?
				raise FileExistsError if @current_dir.get(parts[1])
		
				new_folder = Directory.new(parts[1], @current_dir)
				@current_dir.add(new_folder)
		
			when "show"
				raise IncompleteCommandError, "missing file name" if parts[1].nil?
		
				file = @current_dir.get(parts[1])
				if file
					puts file.show
				else
					raise FileNotFoundError, parts[1]
				end
		
			when "cd"
				raise IncompleteCommandError, "missing path" if parts[1].nil?
		
				dir = get_path(parts[1])
				raise PathNotFoundError, parts[1] if !dir
		
				raise IsNotDirectoryError, parts[1] unless dir.is_a? Directory
				@current_dir = dir
		
			when "destroy"
				raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
				
				print "Are you sure you want to delete #{parts[1]}? (Y to continue): "
				answer = gets.chomp.downcase
				if (answer == "y")
					if @current_dir.find_and_delete(parts[1])
						puts "#{parts[1]} deleted."
					else
						raise FileNotFoundError, parts[1]
					end
				else
					puts "Aborted."
				end
		
			# when "rename"
			# 	raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
			# 	raise IncompleteCommandError, "missing new name" if parts[2].nil?
		
			# 	raise FileExistsError, parts[2] unless @current_dir.get(parts[2]).nil?
		
			# 	f = @current_dir.get(parts[1])
			# 	raise FileNotFoundError, parts[1] if f.nil?
		
			# 	f.rename(parts[2])
		
			when "ls"
				if !parts[1]
					puts @current_dir.show
				else
					dir = get_path(parts[1])
					raise PathNotFoundError, parts[1] if !dir
					puts dir.show
				end
		
			when "metadata"
				raise IncompleteCommandError, "missing file/folder name" if parts[1].nil?
		
				f = @current_dir.get(parts[1])
				raise FileNotFoundError, parts[1] if f.nil?
				
				puts f.metadata
		
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


