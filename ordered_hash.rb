class OrderedHash
    attr_accessor :keys

    def initialize  
        @keys = []
        @values = {}
    end

    def []=(key, value)
        if !keys.include?(key)
            insert_at = @keys.bsearch_index { |k| k >= key }
            insert_at ? @keys.insert(insert_at, key) : @keys.push(key)
        end
        @values[key] = value
    end

    def [](key)
        @values[key]
    end

    def delete(key)
        @keys.delete(key)
        @values.delete(key)
    end
    
    def clear
        @keys.clear
        @values.clear
    end

    def length
        @keys.count
    end

    def each(&block)
        @keys.each { |key| block.call(@values[key]) }
    end

    def map(&block)
        @keys.map { |key| block.call(@values[key]) }
    end

    def values  
        ordered_values = @keys.map { |key| @values[key] }
        Hash[@keys.zip(ordered_values)]
    end


end