class AdminsController < ApplicationController
	skip_before_action :verify_authenticity_token

	before_action :require_authentication

	def require_authentication
		authenticate_or_request_with_http_basic do |u,p|
		true if u == "admin" && p == "admin"
		end
	end

	def showUsers
		@users = User.all
		render 'users'
	end

	def deleteUser(username)
		@user = User.where(username: username).first
		@user.destroy
	end

	def editUser
		@user = User.where(username: request['username']).first
		if request.get?
			render 'editUser'
		else
			if params[:delete]
				deleteUser(params[:user_to_delete])
			elsif params[:edit]
				@user.username = request[:username]
				@user.email = request[:email]
				@user.password = request[:password]
				@user.save
			end
			redirect_to '/users'
		end
	end

	def updateUsers
		if params[:user_to_delete]
			deleteUser(params[:user_to_delete])
			redirect_to '/users'
		elsif params[:user_to_edit]
			puts "LOL"
			puts params[:user_to_edit]
			redirect_to :action => 'editUser', :username => params[:user_to_edit]
		else
			redirect_to '/users'
		end
	end


end
