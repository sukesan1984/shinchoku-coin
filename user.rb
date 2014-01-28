class User
    attr_reader :name, :id
    def initialize(id, name)
        @name = name
        @id   = id
    end
end
