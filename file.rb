require_relative 'utils.rb'

class File
    attr_accessor :name, :content, :created_at, :updated_at

    def initialize(name, content)
        @name = name
        @content = content
        @created_at = get_current_time()
        @updated_at = @created_at
    end
    
    def show
        @content
    end

    def metadata
        data = @name + @created_at + @updated_at
    end

end