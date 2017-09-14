class GamesController < ApplicationController
	
	def showQuestion
		@category = request[:category]
		@subCategory = request[:subCategory]
		@user = User.where(username: session[:username]).first
		@currentGame = @user.games.where(category: @category, subCategory: @subCategory).first
		if @currentGame
			@stateVariable = @currentGame.state.split(';')
			@question = @stateVariable[1].strip
				if @question == request[:question]
					if request.get?
						@showQuestion = Question.where(category: @category, subCategory: @subCategory).limit(@question.to_i + 1)[request[:question].to_i]
						@questionNumber = @question.to_i
						render 'question'
					end
				else
					redirect_to '/dashboard'
				end
		else
			redirect_to '/dashboard'
		end
	end
		
	def play
		if params[:new_game]
			@request = params[:new_game]
		elsif params[:continue_game]
			@request = params[:continue_game]
		else
			redirect_to '/dashboard'
		end

		@choice = @request.split(';')
		@choice[0] = @choice[0].strip
		@choice[1] = @choice[1].strip
		@category = @choice[0]
		@subCategory = @choice[1]

		@size = Question.where(category: @category, subCategory: @subCategory).count
		@start = Random.rand(@size)

		@user = User.where(username: session[:username]).first
		@currentGame = @user.games.where(category: @category, subCategory: @subCategory).first

		if params[:new_game] and @currentGame == nil
			@currentGame = @user.games.new()
			@currentGame.highestScore = 0 			
			@currentGame.category = @category 
			@currentGame.subCategory = @subCategory
			@currentGame.state = @start.to_s + ';' + @start.to_s
		elsif params[:new_game]
			@currentGame.currentScore = 0 
			@currentGame.state = @start.to_s + ';' + @start.to_s
		end

		@currentGame.save
		@stateVariable = @currentGame.state.split(';')
		@question = @stateVariable[1].strip

		redirect_to :action => 'showQuestion', :category => @currentGame.category, :subCategory => @currentGame.subCategory, :question => @question
	end

	def submit
		@user = User.where(username: session[:username]).first
		@category = request[:category]
		@subCategory = request[:subCategory]
		@answer = request[:answer] 
		@currentGame = @user.games.where(category: @category, subCategory: @subCategory).first
		@stateVariable = @currentGame.state.split(';')
		@questionNumber = @stateVariable[1].strip.to_i 
		@question = Question.where(category: @category, subCategory: @subCategory).limit(@questionNumber.to_i + 1)[@questionNumber.to_i]
		@size = Question.where(category: @category, subCategory: @subCategory).count
		if @answer == @question.answer
			@questionNumber = (@questionNumber + 1) % @size
			@currentGame.state = @stateVariable[0] + ';' + @questionNumber.to_s
			@currentGame.currentScore = @currentGame.currentScore + 1
            if @currentGame.currentScore > @currentGame.highestScore
                @currentGame.highestScore = @currentGame.currentScore
            end
            @currentGame.save
			redirect_to :action => 'showQuestion', :category => @currentGame.category, :subCategory => @currentGame.subCategory, :question => @questionNumber
		else
			redirect_to :action => 'showQuestion', :category => @currentGame.category, :subCategory => @currentGame.subCategory, :question => @questionNumber
		end
	end
end
