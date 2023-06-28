require_relative 'utils.rb'

class File
    attr_accessor :name, :content, :created_at, :updated_at

    def initialize(name, content, parent)
        @name = name
        @content = content
        @parent = parent
        @created_at = get_current_time()
        @updated_at = @created_at
    end
    
    def show
        @content
    end

    def metadata
        return "
    Name: #{@name}
    Created: #{@created_at}
    Last modified: #{@updated_at}
    Location: #{location}
        "
    end

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