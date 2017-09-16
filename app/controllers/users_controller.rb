class UsersController < ApplicationController
	
	# before_action :set_user, only: [:check_logged_in, :check_logged_in, :profile]
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

		@games = []
		@first = []
		@second = []
		@first << ['Science', 'Computers', '', 0, 0]
		@first << ['Science', 'Nature', '', 0, 0]
		@second << ['Entertainment', 'Television', '', 0, 0]
		@second << ['Entertainment', 'Books', '', 0, 0]
		@second << ['Entertainment', 'Music', '', 0, 0]

		@games << @first
		@games << @second
		
		@user.games.each do |loopGame|
			@games[ENV[loopGame.category].to_i][ENV[loopGame.subCategory].to_i][2] = loopGame.state
			@games[ENV[loopGame.category].to_i][ENV[loopGame.subCategory].to_i][3] = loopGame.currentScore.to_s 
			@games[ENV[loopGame.category].to_i][ENV[loopGame.subCategory].to_i][4] = loopGame.highestScore.to_s
		end

		render 'dashboard'
	end

	def profile
		if request.get?
			@edit = false
			if request['username']
				if request['username'] and session[:username]
					if request['username'] == session[:username]
						@edit = true
					end
				end
                @user = User.where(username: request['username']).first
				if @user
                    render 'profile'
                else
                    redirect_to '/login'
                end
			else 
				if session[:username]
					@edit = true
					redirect_to :action => 'profile', :username => session[:username]
				else
					redirect_to '/login'
				end
			end
		else
			@user = User.where(username: session[:username]).first
			if request[:delete]
				session[:username] = nil
				@user.destroy
				redirect_to '/login'
			else
				@user.password = request[:password]
				@user.email = request[:email]
				@user.save
				redirect_to '/profile'
			end
		end
	end

	def register
		if request.get?
			render 'register'
		else
			@user = User.new()
			@user.username = request['username']
			@user.email = request['email']
			@user.password = request['password']
			if @user.save
				session[:username] = @user.username
				redirect_to '/profile'
			else 
				redirect_to '/register'
			end
		end
	end

	def logout
		session[:username] = nil
		redirect_to '/login'
	end

	def login
		if request.get?
			render 'login'
		else
			user = User.where(username: params[:username]).first
			if user and user.authenticate(params[:password])
				session[:username] = user.username
				session[:user_id] = user.id
				puts 'session username'
				puts session[:username]
				redirect_to :action => 'profile'
			else 
				redirect_to '/login'
			end
		end
	end

	private

		def set_user
			# puts "set_user"
			# puts params[:username]
			# @user = User.where(username: params[:username]).first
		end

end