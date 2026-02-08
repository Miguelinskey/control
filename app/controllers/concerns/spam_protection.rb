module SpamProtection
  extend ActiveSupport::Concern

  private

  def check_honeypot!
    if params[:website].present?
      redirect_to root_path
    end
  end

  def check_rate_limit!
    return unless current_user

    case controller_name
    when "topics"
      limit, period = 5, 10.minutes
      count = current_user.topics.where("created_at > ?", period.ago).count
    when "posts"
      limit, period = 10, 10.minutes
      count = current_user.posts.where("created_at > ?", period.ago).count
    else
      return
    end

    if count >= limit
      flash[:alert] = "You're posting too quickly. Please wait a few minutes."
      redirect_back fallback_location: root_path
    end
  end

  def check_registration_rate!
    ip = request.remote_ip
    count = User.where(signup_ip: ip).where("created_at > ?", 1.hour.ago).count
    if count >= 3
      flash[:alert] = "Too many accounts created from this address. Please try later."
      redirect_to root_path
    end
  end
end
