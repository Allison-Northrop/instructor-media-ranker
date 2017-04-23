class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :find_user
  before_action :require_login, except: [:root, :index]


  def render_404
    # DPR: supposedly this will actually render a 404 page in production
    raise ActionController::RoutingError.new('Not Found')
  end

  private
  def find_user
    if session[:user_id]
      @login_user = User.find_by(id: session[:user_id])
    end
  end

  def require_login
    find_user
    if @login_user.nil?
      #why is this flash not popping up? Everything else is working
      flash[:status] = :failure
      flash[:messages] = {"Login Error": ["you must log in before viewing content"]}
      redirect_to root_path
    end

  end
end
