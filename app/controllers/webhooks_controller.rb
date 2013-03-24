class WebhooksController < ApplicationController
  protect_from_forgery except: :subscription 
  
  
  inherit_resources
  respond_to :json


  before_filter only: [:subscription] do
    unless authorization?
      return render nothing: true, status: :unauthorized 
    end
  end



  def subscription
    if params[:event] == "invoice.created" or params[:event] == "subscription.updated"
      s = Subscription.find_and_update_status(params)
      return render json: { status: s.status }
    end
    render nothing: true, status: :found
  end





  protected
    def authorization?
      if request.env['HTTP_AUTHORIZATION']
        return request.env['HTTP_AUTHORIZATION'] == ENV['MOIP_AUTHORIZATION']
      end
      return false
    end
end
