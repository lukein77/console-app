require_relative 'file.rb'
require_relative 'ordered_hash.rb'

class Directory < File

    # Initialize directory
    def initialize(name, parent)
        super(name, [], parent)
        @content = OrderedHash.new
    end

    # Add a file or folder to the directory
    def add(f)
        @content[f.name] = f
        update_metadata
    end

    # Return a file or folder by its name
    def get(name)
        return @parent if name == ".."
        return self if name == "." 
        @content[name]
    end

    # Return a directory from a relative path. 
    # If it's not found or the path is incorrect, return nil
    def get_path(path)
        dir = self
        path = path.split("/")
        
        path.each do |d|            
			dir = dir.get(d)
			return nil if dir.nil?
		end

        return dir
    end

    # Find an element and delete it
    def find_and_delete(name)
        f = get(name)

        return nil if f.nil?    # File not found

        if f.is_a? Directory    # If it's a directory, delete all its contents
            f.destroy
        end

        @content.delete(name)   # Remove element from directory
    end

    # Destroy directory.
    # This function is called when deleting from parent directory
    def destroy
        @content.each { |f| f.destroy if f.is_a? Directory }
        @content.clear
    end

    # Show directory's full content (ls command)
    def show
        @content.map(&:name).join(" ")
    end

    # Return full path to this directory
    def full_path
        location + @name + "/"
    end

end