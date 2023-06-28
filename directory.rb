require_relative 'file.rb'

class Directory < File
    attr_accessor :parent

    def initialize(name, parent)
        super(name, [])
        @parent = parent
    end
    
    def show
        if @content.empty?
            return "Directory is empty"
        else
            return @content
        end
    end

end