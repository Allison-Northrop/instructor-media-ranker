class SessionsController < ApplicationController
  before_action :require_login, except: [:root, :index, :create]

  def login_form
  end

  # def login
  #   username = params[:username]
  #   if username and user = User.find_by(username: username)
  #     session[:user_id] = user.id
  #     flash[:status] = :success
  #     flash[:result_text] = "Successfully logged in as existing user #{user.username}"
  #   else
  #     user = User.new(username: username)
  #     if user.save
  #       session[:user_id] = user.id
  #       flash[:status] = :success
  #       flash[:result_text] = "Successfully created new user #{user.username} with ID #{user.id}"
  #     else
  #       flash.now[:status] = :failure
  #       flash.now[:result_text] = "Could not log in"
  #       flash.now[:messages] = user.errors.messages
  #       render "login_form", status: :bad_request
  #       return
  #     end
  #   end
  #   redirect_to root_path
  # end
  #
  def logout
    session[:user_id] = nil
    flash[:status] = :success
    flash[:result_text] = "Successfully logged out"
    redirect_to root_path
  end

  def create
    auth_hash = request.env['omniauth.auth']
    @user = User.find_by(oauth_uid: auth_hash[:uid], oauth_provider: 'github')
    if @user.nil?
      @user = User.from_github(auth_hash)
      if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Logged in"
      else
        flash[:message] = "unsuccessful"
      end
    else
      session[:user_id] = @user.id
    end
    redirect_to root_path
  end




  def index
    @user = User.find(session[user_id])
  end

end
