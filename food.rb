class Apple 
    attr_reader :x, :y
    def initialize(image)
        @image = image
        # allows for random position of apple within borders of window
        @x=rand(10..620)
        @y=rand(50..460)
    end
    def draw
		@image.draw(@x,@y,1,1,1)
    end
end

class Poison
    attr_reader :x, :y
    def initialize(image)
        @image = image
        # allows for random position of skulls within borders of window
        @x=rand(10..620)
        @y=rand(50..460)
    end
    def draw
		@image.draw(@x,@y,1,1,1)
    end
end