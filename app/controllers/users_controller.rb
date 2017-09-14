class UsersController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	before_action :check_logged_in, only: [:logout, :profile, :index]
	before_action :check_not_logged_in, only: [:register, :login]
	
	def check_logged_in
		if not session[:username]
			redirect_to '/login'
		end
	end

	def check_not_logged_in
		if session[:username]
			redirect_to '/profile'
		end
	end

	def index
		@user = User.where(username: session[:username]).first

		@games = [], @first = [], @second = []
		@first << ['Science', 'Computers', '', 0, 0]
		@first << ['Science', 'Nature', '', 0, 0]
		@second << ['Entertainment', 'Television', '', 0, 0]
		@second << ['Entertainment', 'Books', '', 0, 0]
		@second << ['Entertainment', 'Music', '', 0, 0]

		@games << []
		@games << @first
		@games << @second
		
		@user.games.each do |loopGame|
			@games[loopGame.category][loopGame.subCategory][2] = loopGame.state 
			@games[loopGame.category][loopGame.subCategory][3] = loopGame.currentScore 
			@games[loopGame.category][loopGame.subCategory][4] = loopGame.highestScore
		end

		render 'dashboard'
	end

	def register
		if request.get?
			render 'register'
		else
			@user = User.new()
			@user.username = request['username']
			@user.email = request['email']
			@user.password = request['password']
			puts @user.username
			if @user.save
				session[:username] = @user.username
				redirect_to '/profile'
			else 
				redirect_to '/register'
			end
		end
	end

	def login
		if request.get?
			render 'login'
		else
			@username = User.authenticate(request['username'], request['password'])
			if @username
				puts "true"
				session[:username] = @username
				puts session[:username]
				redirect_to '/profile'
			else 
				redirect_to '/login'
			end
		end
	end

	def profile
		if request['username']
			render 'profile', locals: {username: request['username']}
		else 
			if session[:username]
				redirect_to :action => 'profile', :username => session[:username]
			else
				redirect_to '/login'
			end
		end
	end

	def play
		if params[:new_game]
			@choice = params[:new_game].split(';')
			@choice[0] = @choice[0].strip
			@choice[1] = @choice[1].strip
			@category = ENV[@choice[0]]
			@subCategory = ENV[@choice[1]]

		elsif params[:continue_game]
			@choice = params[:continue_game].split(';')
			@choice[0] = @choice[0].strip
			@choice[1] = @choice[1].strip
			@category = ENV[@choice[0]]
			@subCategory = ENV[@choice[1]]
			
		end
	end

	def logout
		session[:username] = nil
		redirect_to '/login'
	end

end