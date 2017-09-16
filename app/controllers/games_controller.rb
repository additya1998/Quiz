class GamesController < ApplicationController
	
	before_action :get_user
	before_action :fetch_data, only: [:showQuestion, :submit]

	def showQuestion
		if @currentGame
			@stateVariable = @currentGame.state.split(';')
			@question = @stateVariable[1].strip
				if @question == request[:question]
					if request.get?
						@showQuestion = Question.where(category: @category, subCategory: @subCategory).limit(@question.to_i + 1)[request[:question].to_i]
						arrayToShuffle = [@showQuestion.firstOption, @showQuestion.secondOption, @showQuestion.thirdOption, @showQuestion.fourthOption]
                        arrayToShuffle = arrayToShuffle.shuffle
                        @showQuestion.firstOption = arrayToShuffle[0]
                        @showQuestion.secondOption = arrayToShuffle[1]
                        @showQuestion.thirdOption = arrayToShuffle[2]
                        @showQuestion.fourthOption = arrayToShuffle[3]
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
		@answer = request[:answer] 
        @stateVariable = @currentGame.state.split(';')
        @questionNumber = @stateVariable[1].strip.to_i 
        @question = Question.where(category: @category, subCategory: @subCategory).limit(@questionNumber.to_i + 1)[@questionNumber.to_i]
        @size = Question.where(category: @category, subCategory: @subCategory).count
        puts @answer
        puts @question.answer
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

	def leaderboard
		@data = []

		@data << ['Science', 'Computers', []]
		array = Game.where(category: 'Science', subCategory: 'Computers').order('highestScore').reverse_order.limit(10)
		array.each do |record|
			@data[0][2] << [record.user.username, record.highestScore]
		end

		@data << ['Science', 'Nature', []]
		array = Game.where(category: 'Science', subCategory: 'Nature').order('highestScore').reverse_order.limit(10)
		array.each do |record|
			@data[1][2] << [record.user.username, record.highestScore]
		end

		@data << ['Entertainment', 'Television', []]
		array = Game.where(category: 'Entertainment', subCategory: 'Television').order('highestScore').reverse_order.limit(10)
		array.each do |record|
			@data[2][2] << [record.user.username, record.highestScore]
		end

		@data << ['Entertainment', 'Books', []]
		array = Game.where(category: 'Entertainment', subCategory: 'Books').order('highestScore').reverse_order.limit(10)
		array.each do |record|
			@data[3][2] << [record.user.username, record.highestScore]
		end

		@data << ['Entertainment', 'Music', []]
		array = Game.where(category: 'Entertainment', subCategory: 'Music').order('highestScore').reverse_order.limit(10)
		array.each do |record|
			@data[4][2] << [record.user.username, record.highestScore]
		end

		render 'leaderboard'
	end

	private

		def get_user
			@user = User.where(username: session[:username]).first
		end

		def fetch_data
			@category = request[:category]
			@subCategory = request[:subCategory]
			@currentGame = @user.games.where(category: @category, subCategory: @subCategory).first
		end
end
