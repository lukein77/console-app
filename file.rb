require_relative 'utils.rb'

class MyFile
    attr_accessor :name, :parent

    # Initialize file
    def initialize(name, content, parent)
        @name = name
        @content = content
        @parent = parent
        @created_at = get_current_time()
        @updated_at = @created_at
    end
    
    # Rename file
    def rename(name)
        @name = name
        update_metadata
    end

    # Show file content
    def show
        @content
    end

    # Show metadata
    def metadata
        return "
    Name: #{@name}
    Created: #{@created_at}
    Last modified: #{@updated_at}
    Location: #{location}
        "
    end

    # Get file location
    def location
        if @parent
            @parent.full_path
        else
            return ''
        end
    end


    private

    def update_metadata
        @updated_at = get_current_time()
    end

end