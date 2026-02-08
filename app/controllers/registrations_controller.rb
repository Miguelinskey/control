class RegistrationsController < ApplicationController
  include SpamProtection

  before_action :check_honeypot!, only: :create
  before_action :check_registration_rate!, only: :create

  def new
    @user = User.new
  end

  def check_username
    username = params[:username].to_s.strip
    if username.length < 2
      render json: { available: false, message: "Username must be at least 2 characters" }
    elsif User.exists?(username: username)
      render json: { available: false, message: "Username is already taken" }
    else
      render json: { available: true, message: "Username is available" }
    end
  end

  def create
    @user = User.new(user_params)
    @user.signup_ip = request.remote_ip
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome, #{@user.username}!"
      redirect_to root_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :password, :password_confirmation)
  end
end
