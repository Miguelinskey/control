class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      if user.banned?
        flash.now[:alert] = "Account suspended."
        render :new, status: :unprocessable_entity
      else
        session[:user_id] = user.id
        flash[:notice] = "Logged in as #{user.username}."
        redirect_to root_path
      end
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session.delete(:user_id)
    flash[:notice] = "Logged out."
    redirect_to root_path
  end
end
