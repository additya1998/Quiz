class GamesController < ApplicationController
	
	before_action :check_logged_in, only: [:showQuestion, :play, :submit, :get_user]
	before_action :get_user
	before_action :fetch_data, only: [:showQuestion, :submit]

	def check_logged_in
		if not session[:username]
			redirect_to '/login'
		end
	end

	def showQuestion
		if @currentGame
			@stateVariable = @currentGame.state.split(';')
			@question = @stateVariable[1].strip
			@firstLifeline = @stateVariable[2].strip
			@secondLifeline = @stateVariable[3].strip
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
			@currentGame.state = @start.to_s + ';' + @start.to_s + ';1;1'
		elsif params[:new_game]
			@currentGame.currentScore = 0 
			@currentGame.state = @start.to_s + ';' + @start.to_s + ';1;1'
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

		if request[:lifeline]
			if request[:lifeline] == 'skip'
				@firstLifelineUsed = 1
				@stateVariable[2] = 0
			end
			if request[:lifeline] == 'doubleScore'
				@secondLifelineUsed = 1
				@stateVariable[3] = 0	
			end
		end

		correct = 0
		if request[:answer] != nil
			if @question.typeOfQuestion.to_i == 2
				correct = checkMulti
			else
				correct = checkSingle
			end
		end

		if @firstLifelineUsed.to_i == 1
			correct = 1
		end

		if correct.to_i != 0
			@addToScore = 1
			if @secondLifelineUsed.to_i == 1
				@addToScore = 2
			end
			@questionNumber = (@questionNumber + 1) % @size
			@currentGame.state = @stateVariable[0] + ';' + @questionNumber.to_s + ';' + @stateVariable[2].to_s + ';' + @stateVariable[3].to_s 		
			@currentGame.currentScore = @currentGame.currentScore + @addToScore
			if @currentGame.currentScore > @currentGame.highestScore
				@currentGame.highestScore = @currentGame.currentScore
			end
			@currentGame.save
			redirect_to :action => 'showQuestion', :category => @currentGame.category, :subCategory => @currentGame.subCategory, :question => @questionNumber
		else
			@gameScore = @currentGame.currentScore
			@currentGame.state = nil
			@currentGame.currentScore = 0
			@currentGame.save
			render 'gameover'
			# redirect_to :action => 'showQuestion', :category => @currentGame.category, :subCategory => @currentGame.subCategory, :question => @questionNumber
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

		def checkMulti
			@correctAnswers = @question.answer.split(';')
			@answer.each do |answer|
				answerFound = 0
				@correctAnswers.each do |currentAnswer|
					if answer == currentAnswer
						answerFound = 1
					end
				end
				if answerFound == 0
					return 0
				end
			end
			return 1
		end

		def checkSingle
			if @answer == @question.answer
				return 1
			else
				return 0
			end
		end
end
