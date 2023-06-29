require_relative 'file.rb'

class Directory < File
    attr_accessor :parent, :children

    # Initialize directory.
    # @content = files, @children = subdirectories, @parent = parent directory
    def initialize(name, parent)
        super(name, [], parent)
        @children = []
    end
    
    # Add a folder to subdirectories
    def add_folder(folder)
        @children.push(folder)
        update_metadata
    end

    # Add a file to directory's content
    def add_file(file)
        @content.push(file)
        update_metadata
    end

    # Get file or folder from its name
    def get_element(name)
        get_folder(name) || get_file(name)
    end

    # Return a folder from its name
    def get_folder(name)
        return @parent if name == ".."
        return self if name == "." 
        @children.find { |folder| folder.name == name }
    end

    # Return a file from its name
    def get_file(name)
        @content.find { |file| file.name == name }
    end

    # Return a directory from a relative path. 
    # If it's not found or the path is incorrect, return nil
    def get_relative_path(path)
        path = path.split("/")      
        return nil if path.empty?   

        dir = self
        path.each do |d|            
			dir = dir.get_folder(d)
			return nil if dir.nil?
		end

        return dir
    end
    
    # Find an element and delete it
    def find_and_delete(name)
        # If it's a file, just delete it
        f = get_file(name)
        return @content.delete(f) unless f.nil?

        # If it's a directory, we have to delete everything inside it first
        f = get_folder(name)
        return nil if f.nil?
        
        f.destroy
        @children.delete(f)        
    end

    # Destroy directory. 
    # This function is called when deleting from parent directory
    def destroy
        @content.clear
        @children.each do |dir| 
            dir.destroy
        end
        @children.clear
    end

    # Show directory's full content (ls command)
    def show
        @full_dir = @children + @content
        @full_dir.map(&:name).join(" ")
    end

    # Return full path to this directory
    def full_path
        location + @name + "/"
    end

end