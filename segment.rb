class Segment#used for creating the snake for player 1
    attr_accessor :x, :y

    def initialize(window, position)
		@window = window
		@x = position[0]
		@y = position[1]
	end

	def draw
		@window.draw_quad(@x, @y,       Gosu::Color::GREEN,
                      @x + 10, @y,      Gosu::Color::GREEN,
                      @x, @y + 10,      Gosu::Color::WHITE,
                      @x + 10, @y + 10, Gosu::Color::WHITE)#draws a square 
    end
end

class Segment2#used for creating the snake for player 2
    attr_accessor :x, :y

    def initialize(window, position)
		@window = window
		@x = position[0]
		@y = position[1]
	end

    def draw
		@window.draw_quad(@x, @y,       Gosu::Color::AQUA,
                      @x + 10, @y,      Gosu::Color::AQUA,
                      @x, @y + 10,      Gosu::Color::WHITE,
                      @x + 10, @y + 10, Gosu::Color::WHITE)#draws a square 
    end

end