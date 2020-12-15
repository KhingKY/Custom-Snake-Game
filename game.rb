#connect all the files and library together
require 'gosu'
require_relative 'food.rb'
require_relative 'segment.rb'
require_relative 'snake.rb'


class GameWindow<Gosu::Window
    def initialize
        super(640,480,false)
        self.caption="Snake Survival"
        @background_image = Gosu::Image.new("media/background.png")
        @snake1=Snake.new(self,Segment)
        @snake2=Snake.new(self,Segment2)
        @apple_image=Gosu::Image.new("media/apple.png")
        @apple=Apple.new(@apple_image)
        @poison_image=Gosu::Image.new("media/skull.png")
        #This loop is to create multiple poison skulls by evaluating the string "@poison#{i} = Poison.new(@poison_image)". The binding makes it so that the evaluation will be performed in the context. In this case, @poison#{i} = Poison.new(@poison_image). This will result in making multiple of the same value but different variable. For example, @poison1, @poison2, @poison3 etc will be created and all will be assigned the value of Poison.new(@poison_image)
        15.times do |i|
          eval("@poison#{i} = Poison.new(@poison_image)", binding)
        end
        @score1=0
        @score2=0
        @message=Gosu::Font.new(self,'Arial',28)
        @eat = Gosu::Sample.new("media/eat.wav")
        @eat_skull=Gosu::Sample.new("media/die.mp3")
        
    end

    
    def update
        #-------------------Player 1(aka snake 1) uses W,A,S,D buttons to move--------------------------------
        if (button_down? Gosu::KbA) && (@snake1.direction != "right")
            @snake1.direction = "left"
        elsif(button_down? Gosu::KbD) && @snake1.direction != "left"
			@snake1.direction = "right"
		elsif(button_down? Gosu::KbW) && @snake1.direction != "down"
			@snake1.direction = "up"
        elsif(button_down? Gosu::KbS) && @snake1.direction != "up"
			@snake1.direction = "down"
        end

        #-----------------------------Player 2(aka snake 2) uses arrow buttons to move-----------------------------------
        if (button_down? Gosu::KbLeft) && (@snake2.direction != "right")
			@snake2.direction = "left"
		elsif(button_down? Gosu::KbRight) && @snake2.direction != "left"
			@snake2.direction = "right"
		elsif(button_down? Gosu::KbUp) && @snake2.direction != "down"
			@snake2.direction = "up"
		elsif(button_down? Gosu::KbDown) && @snake2.direction != "up"
			@snake2.direction = "down"
        end

        #If the player press escape button, the window will close
        if button_down? Gosu::KbEscape
            self.close
            if @player1_win
                currentTime = Time.new
                history = File.new("ScoreBoard.txt", "a")
                history.puts("Player 1 WIN")
                history.puts("Time: "+currentTime.inspect)
                history.puts("Player 1 Score: #{@score1}\t\tPlayer 2 Score: #{@score2}")
                history.puts @reason
                history.puts("_____________________________________________________________")
                history.close()
            elsif @player2_win
                currentTime = Time.new
                history = File.new("ScoreBoard.txt", "a")
                history.puts("Player 2 WIN")
                history.puts("Time: "+currentTime.inspect)
                history.puts("Player 1 Score: #{@score1}\t\tPlayer 2 Score: #{@score2}")
                history.puts @reason
                history.puts("_____________________________________________________________")
                history.close()
            end
        end
        
        #If either of the player wins, and presses the Enter button, the game will restart
        if (@player1_win||@player2_win) && (button_down? Gosu::KbReturn)
            if @player1_win
                currentTime = Time.new
                history = File.new("ScoreBoard.txt", "a")
                history.puts("Player 1 WIN")
                history.puts("Time: "+currentTime.inspect)
                history.puts("Player 1 Score: #{@score1}\t\tPlayer 2 Score: #{@score2}")
                history.puts @reason
                history.puts("_____________________________________________________________")
                history.close()
            elsif @player2_win
                currentTime = Time.new
                history = File.new("ScoreBoard.txt", "a")
                history.puts("Player 2 WIN")
                history.puts("Time: "+currentTime.inspect)
                history.puts("Player 1 Score: #{@score1}\t\tPlayer 2 Score: #{@score2}")
                history.puts @reason
                history.puts("_____________________________________________________________")
                history.close()
            end
            @player1_win = nil
            @player2_win = nil
            @snake1=Snake.new(self,Segment)
            @snake2=Snake.new(self,Segment2)
            @apple=Apple.new(@apple_image)
            15.times do |i|
                eval("@poison#{i} = Poison.new(@poison_image)", binding)
            end
            @score1=0
            @score2=0
            
            
        end
        
        #When player 1 eats the apple
        if @snake1.eat_apple?(@apple)
            @eat.play
            @apple=Apple.new(@apple_image)
            @score1+=10
            @snake1.ticker+=11
            @snake1.length+=10
            @snake1.speed+=0.1
            @snake2.speed+=0.1
        end

        #When player 2 eats the apple
        if @snake2.eat_apple?(@apple)
            @eat.play
            @apple=Apple.new(@apple_image)
            @score2+=10
            @snake2.ticker+=11
            @snake2.length+=10
            @snake1.speed+=0.1
            @snake2.speed+=0.1
        end

        if @score1<@score2
            @snake1.speed=@snake2.speed+0.5
        elsif @score2<@score1
            @snake2.speed=@snake1.speed+0.5
        else
            @snake1.speed=@snake2.speed
        end

        #This is loop is for when the player eats the skull
        15.times do |i| #15 because it needs to evaluate all the 15 skulls
            @poison= instance_variable_get("@poison#{i}") #gets the instance variable @poison(1/2/3...)
            if @snake1.eat_apple?(@poison)
                eval("@poison#{i} = Poison.new(@poison_image)", binding)#evaluates @poison#{i} = Poison.new(@poison_image) to run the statement according to the number in i. For example, if @snake1 eats @poison1, then @poison1== Poison.new(@poison_image) will run
                @score1=0
                @snake1=Snake.new(self,Segment)
                @snake1.speed=1.5
                @eat_skull.play
            #if snake 2 eats the skull
            elsif @snake2.eat_apple?(@poison)
                eval("@poison#{i} = Poison.new(@poison_image)", binding)
                @score2=0
                @snake2=Snake.new(self,Segment)
                @snake2.speed=1.5
                @eat_skull.play
            end
        end
        #This block translates to if either one of the skulls is eaten by the snake, then the snake's score and speed will reset, the snake will respawn at somewhere else and the skull will also respawn at somewhere else

        #if the snakes collide to the wall of the window
        if @snake1.hit_wall?
            @player2_win = Gosu::Font.new(self, 'Arial', 32)
            @reason="PLAYER 1 HIT THE WALL"
        elsif @snake2.hit_wall?
            @player1_win = Gosu::Font.new(self, 'Arial', 32)
            @reason="PLAYER 2 HIT THE WALL"
        end

        #if the snakes collides with its own body part
        if @snake1.hit_self?
            @player2_win = Gosu::Font.new(self, 'Arial', 32)
            @reason="PLAYER  1  HIT   ITSELF"
        elsif @snake2.hit_self?
            @player1_win = Gosu::Font.new(self, 'Arial', 32)
            @reason="PLAYER  2  HIT   ITSELF"
        end

        #Win condition: Either one of the players have to accumulate up to 100 points without eating a single skull
        if @score1==100
            @player1_win = Gosu::Font.new(self, 'Arial', 32)
            @reason=" "
        elsif @score2==100
            @player2_win = Gosu::Font.new(self, 'Arial', 32)
            @reason=" "
        end

        if @snake1.ticker>0 #to prevent the snakes from getting longer indefinitely after eating an apple as the tail end will get stuck at the same position
            @snake1.ticker-=1
        elsif @snake2.ticker>0
            @snake2.ticker-=1
        end
    end

    def read_instructions
        instructions_array=Array.new()
        instructions_file=File.new("instructions.txt","r")
        line_no=instructions_file.gets.chomp.to_i

        for i in 0..line_no-1
            instructions=instructions_file.gets.chomp
            instructions_array<<instructions
        end
        instructions_file.close()
        return instructions_array

    end

    def display_instructions
        @instructions_text = Gosu::Font.new(self, 'Arial', 24)
        @show_instructions=read_instructions
        @instructions_text.draw_text("INSTRUCTIONS",160,10,2,2,2)
        x=20
        y=50
        for i in 0..@show_instructions.length-1
            if i==4 || i==5
                x=80
                if i==5
                    y+=30
                end
            elsif i==1||i==2
                y+=80
            end
            @instructions_text.draw_text(@show_instructions[i],x,y,2,1,1)
            y+=40
        end
        
        @green_snake=Gosu::Image.new("media/snake1.png")
        @green_snake.draw(200,100,1,0.1,0.1)
        @blue_snake=Gosu::Image.new("media/snake2.png")
        @blue_snake.draw(200,240,1,0.1,0.1)
        @controls1=Gosu::Image.new("media/wasd.png")
        @controls1.draw(300, 70,1,0.2,0.2)
        @controls2=Gosu::Image.new("media/arrows.png")
        @controls2.draw(300, 190,1,0.2,0.2)
        @apple_image.draw(30,360,1,2,2)
        @poison_image.draw(30,430,1,2,2)
        @background_image.draw(0, 0, 0)
    end

    def draw
        if @player1_win#if player 1 wins, these will show on the screen
            @background_image.draw(0, 0, 0)
            @player1_win.draw_text("PLAYER 1 WINS", 160, 180, 2,1.5,1.5)
            @player1_win.draw_text(@reason, 160, 250, 2,1,1,Gosu::Color::RED)
            @player1_win.draw_text("Player 1 Score: #{@score1}",10,10,2,0.8,0.8)
            @player1_win.draw_text("Player 2 Score: #{@score2}",430,10,2,0.8,0.8)
            @player1_win.draw_text("Press ENTER to Try Again", 10, 400, 2,0.8,0.8)
            @player1_win.draw_text("Or Escape to Close", 440, 400, 2,0.8,0.8)
            

        #if player 2 wins, these will show on the screen
        elsif @player2_win
            @background_image.draw(0, 0, 0)
            @player2_win.draw_text("PLAYER 2 WINS", 160, 180, 2,1.5,1.5)
            @player2_win.draw_text(@reason, 160, 250, 2,1,1,Gosu::Color::RED)
            @player2_win.draw_text("Player 1 Score: #{@score1}",10,10,2,0.8,0.8)
            @player2_win.draw_text("Player 2 Score: #{@score2}",430,10,2,0.8,0.8)
            @player2_win.draw_text("Press ENTER to Try Again", 10, 400, 2,0.8,0.8)
            @player2_win.draw_text("Or Escape to Close", 440, 400, 2,0.8,0.8)

            

        #if no one won yet, then it will draw all the components and characters for the game to start here    
        elsif (button_down?Gosu::KbI)
            display_instructions
        else
            @background_image.draw(0, 0, 0)
            @snake1.draw
            @snake1.update_position(Segment)
            @snake2.draw
            @snake2.update_position(Segment2)
            @apple.draw
            #creates 15 @poison(1-15).draw commands
            15.times do |i|
            eval("@poison#{i}.draw", binding)
            end
            @message.draw_text("Player 1 Score: #{@score1}",10,10,2,1,1, Gosu::Color::GREEN)
            @message.draw_text("Player 2 Score: #{@score2}",400,10,2,1,1,Gosu::Color::AQUA)
            
            @message.draw_text("Hold down 'I' for instructions",170,450,2,1,1)
        end
    end 

end

    window=GameWindow.new
    window.show

