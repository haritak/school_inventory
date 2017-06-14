class SessionsController < ApplicationController
  skip_before_action :authorize

  def new
  end

  def create
    user = User.find_by( username: params[ :username ] )
    if user&.authenticate( params[:password] )
      session[:user_id] = user.id
      session[:username] = user.username
      redirect_to items_url
    else
      redirect_to login_url, alert: "Invalid username/password"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_url, notice: "You have been logged out"
  end
end
