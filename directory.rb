require_relative 'file.rb'

class Directory < File
    attr_accessor :parent

    def initialize(name, parent)
        super(name, [])
        @parent = parent
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
        if name == ".." 
            return @parent
        elsif name == "."
            return self
        end
        @children.find { |folder| folder.name == name }
    end

    def get_file(name)
        @content.find { |file| file.name == name }
    end

    def show
        @full_dir = @children + @content
        @full_dir.map(&:name).join(" ")
    end

    def full_path
        if @parent
            @parent.full_path + @name + "/" 
        else
            @name
        end
    end

end