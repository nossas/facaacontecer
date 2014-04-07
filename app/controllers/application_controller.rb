class ApplicationController < ActionController::Base
  protect_from_forgery




  # Turn on SSL only for given actions in production
  def ssl_configured?
    Rails.env.production?
  end
end
