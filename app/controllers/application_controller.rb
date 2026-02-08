class ApplicationController < ActionController::Base
  include Authentication

  allow_browser versions: :modern

  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private

  def not_found
    render file: Rails.public_path.join("404.html"), status: :not_found, layout: false
  end
end
