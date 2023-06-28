require_relative 'file.rb'

class Directory < File
    attr_accessor :parent, :children

    def initialize(name, parent)
        super(name, [], parent)
        @children = []
    end
    
    def add_folder(folder)
        @children.push(folder)
        update_metadata
    end

    def add_file(file)
        @content.push(file)
        update_metadata
    end

    def get_element(name)
        get_folder(name) || get_file(name)
    end

    def get_folder(name)
        return @parent if name == ".."
        return self if name == "." 
        @children.find { |folder| folder.name == name }
    end

    def get_file(name)
        @content.find { |file| file.name == name }
    end
    
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

    def destroy
        @content.clear
        @children.each do |dir| 
            dir.destroy
        end
        @children.clear
    end

    def show
        @full_dir = @children + @content
        @full_dir.map(&:name).join(" ")
    end

    def full_path
        location + @name + "/"
    end

end