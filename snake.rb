class Snake
    attr_accessor :direction, :x, :y, :speed, :length, :segment, :ticker

    def initialize(window,segment)
        @window=window
        @x=rand(320)
        @y=rand(200)
        @segments=[]
        @direction="right"
        @first_segment=segment.new(@window,[@x,@y])#creates the first segment of the snake
        @segments.push(@first_segment)#appends the first segment into the segment array
        @speed=1.5
        @length = 1
        @ticker=0# Counts up to lengthen the snake each tick when it has eaten an apple
        
    end

    def draw
        for body in @segments
            body.draw
        end
        #for each element in the @segment array, draw a segment
    end

    def add_segment(segment)
        if @direction=="left"
            x=@first_segment.x-@speed#x coordinates -@speed to add new segments to the left
            y=@first_segment.y#y coordinates doesnt change
            new_segment= segment.new(@window, [x,y])#creates a new segment based on the new x and y coordinates
        end
        if @direction=="right"
            x=@first_segment.x+@speed#x coordinates +@speed to add new segments to the right
            y=@first_segment.y#y coordinates doesnt change
            new_segment= segment.new(@window, [x,y])#creates a new segment based on the new x and y coordinates
        end
        if @direction=="up"
            x=@first_segment.x#x coordinates doesnt change
            y=@first_segment.y-@speed#y coordinates -@speed to add new segments on top
            new_segment= segment.new(@window, [x,y])#creates a new segment based on the new x and y coordinates
        end
        if @direction=="down"
            x=@first_segment.x#x coordinates doesnt change
            y=@first_segment.y+@speed#x coordinates +@speed to add new segments below
            new_segment= segment.new(@window, [x,y])#creates a new segment based on the new x and y coordinates
        end
        @first_segment=new_segment
        @segments.push(@first_segment)#adds the new segments into the @segments array
    end

    def update_position(segment)
        add_segment(segment)
		unless @ticker>0
			@segments.shift #removes the first segment of the snake which means 
		end
    end

    def eat_apple?(apple)
        if Gosu::distance(@first_segment.x,@first_segment.y,apple.x,apple.y)<14 #if the distance between the snake's head and the apple is lesser than 14, then return true
            return true
        end
    end

	def hit_self?
		segments = Array.new(@segments)
		if segments.length > 21
			# Gets the array after the first segment
			segments.pop((10 * @speed))#Removes 10*@speed elements counting from the head segment which means that the array is only left with the body
			segments.each do |segment| 
				if Gosu::distance(@first_segment.x, @first_segment.y, segment.x, segment.y) < 11#if the distance between the snake's head and the snake's body is lesser than 11, then return true
					return true
        		end
			end
			false
		end

    end
    
    def hit_wall?
        #if the head of the snake is either lower than the minimum x coordinates or higher than the maximum x coordinates then return true
		if @first_segment.x < 0 || @first_segment.x > 630 #640-10 so that exactly one block can travel along the edge of the block only
            true
        #if the head of the snake is either lower than the minimum y coordinates or higher than the maximum y coordinates then return true
		elsif @first_segment.y < 0 || @first_segment.y > 470 #480-10 so that exactly one block can travel along the edge of the block only
			true
		else
			false
		end
	end

end
