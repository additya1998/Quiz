class UserController < ApplicationController
	skip_before_action :verify_authenticity_token
	
	before_action :check_logged_in, only: [:logout]
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
				session[:username] = @user.id
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
			@id = User.authenticate(request['username'], request['password'])
			if @id
				puts "true"
				session[:username] = @id
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

	def logout
		session[:username] = nil
		redirect_to '/login'
	end
end