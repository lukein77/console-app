require_relative 'utils.rb'

class File
    def initialize(name, content)
        @name = name
        @content = content
        @created_at = get_current_time()
    end
    
    def show
        @content
    end

end