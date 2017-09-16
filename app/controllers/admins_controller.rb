class AdminsController < ApplicationController

	before_action :require_authentication

	def require_authentication
		authenticate_or_request_with_http_basic do |u,p|
		@admin = Admin.where(username: u, password: p).first
		true if @admin
		end
	end

	def showUsers
		@users = User.all
		render 'showUsers'
	end
	def deleteUser(username)
		@user = User.where(username: username).first
		if @user
			if session[:username] == @user.username
				session[:username] = nil
			end
			@user.destroy

		end
	end
	def editUser
		if request.get?
			@user = User.where(username: request['username']).first
			render 'editUser'
		else
			@user = User.where(username: params[:edit]).first
			if params[:delete]
				deleteUser(params[:delete])
			elsif params[:edit]
                if request[:email].to_s != nil
                    @user.email = request[:email]
                end
                @user.email = request[:email]
				if request[:password].to_s != nil
                    @user.password = request[:password]
                end
				@user.save
			end
			redirect_to '/admin/showUsers'
		end
	end
	def updateUser
		if params[:user_to_delete]
			deleteUser(params[:user_to_delete])
			redirect_to '/admin/showUsers'
		elsif params[:user_to_edit]
			redirect_to :action => 'editUser', :username => params[:user_to_edit]
		else
			redirect_to '/admin/showUsers'
		end
	end
	def registerUser
		if request.get?
			render 'registerUser'
		else
			@user = User.new()
			@user.username = request['username']
			@user.email = request['email']
			@user.password = request['password']
			if @user.save
				redirect_to '/admin/showUsers'
			else 
				redirect_to '/admin/registerUser'
			end
		end
	end

	def showAdmins
		@admins = Admin.all
		render 'showAdmins'
	end
	def registerAdmin
		if request.get?
			render 'registerAdmin'
		else
			@admin = Admin.new()
			@admin.username = request['username']
			@admin.password = request['password']
			if @admin.save
				redirect_to '/admin/showAdmins'
			else 
				redirect_to '/admin/registerAdmin'
			end
		end
	end

    def showQuestions
        @questions = Question.all
        render 'showQuestions'
    end
    def deleteQuestion(question)
        question = question.to_i
        @question = Question.find(question)
        if @question
            @question.destroy
        end
    end
    def editQuestion
        if request.get?
            @question = Question.find(request['id'].to_i)
            render 'editQuestion'
        else
            if params[:delete]
                deleteQuestion(params[:delete])
            elsif params[:edit]
                @question = Question.find(params[:edit].to_i)
                @question.question = params['question'] 
                @question.firstOption = params['firstOption'] 
                @question.secondOption = params['secondOption'] 
                @question.thirdOption = params['thirdOption']
                @question.fourthOption = params['fourthOption']
                @question.answer = params['answer'] 
                @question.category = params['category'] 
                @question.subCategory = params['subCategory'] 
                @question.typeOfQuestion = params['typeOfQuestion'] 
                @question.save
            end
            redirect_to '/admin/showQuestions'
        end
    end
    def updateQuestion
        if params[:question_to_delete]
            deleteQuestion(params[:question_to_delete])
            redirect_to '/admin/showQuestions'
        elsif params[:question_to_edit]
            redirect_to :action => 'editQuestion', :id => params[:question_to_edit]
        else
            redirect_to '/admin/showQuestions'
        end
    end
    def addQuestion
        if request.get?
            render 'registerQuestion'
        else
            @question = Question.new()
            @question.question = params['question'] 
            @question.firstOption = params['firstOption'] 
            @question.secondOption = params['secondOption'] 
            @question.thirdOption = params['thirdOption']
            @question.fourthOption = params['fourthOption']
            @question.answer = params['answer'] 
            @question.category = params['category'] 
            @question.subCategory = params['subCategory'] 
            @question.typeOfQuestion = params['typeOfQuestion'] 
            @question.save
            redirect_to '/admin/showQuestions'
        end
    end



end
