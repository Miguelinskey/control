module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :logged_in?
  end

  private

  def current_user
    return @current_user if defined?(@current_user)

    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
    if @current_user&.banned?
      session.delete(:user_id)
      @current_user = nil
    end
    @current_user
  end

  def logged_in?
    current_user.present?
  end

  def require_authentication
    unless logged_in?
      flash[:alert] = "You must be logged in."
      redirect_to login_path
    end
  end

  def require_admin
    unless logged_in? && current_user.admin?
      flash[:alert] = "Not authorized."
      redirect_to root_path
    end
  end

  def require_staff
    unless logged_in? && current_user.staff?
      flash[:alert] = "Not authorized."
      redirect_to root_path
    end
  end
end
