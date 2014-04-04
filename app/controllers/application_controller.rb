class ApplicationController < ActionController::Base
  protect_from_forgery



  def ssl_configured?
    Rails.env.production?
  end
end
