class UsersController < ApplicationController
  inherit_resources
  before_filter only: [:new] do
    @token = Base64.encode64("#{MOIP_TOKEN}:#{MOIP_KEY}")
  end
  respond_to :json, only: :create
  
  def new
    @project = Project.find_by_id(params[:project_id])
    new!
  end

  def create
    create! do |success, failure|
      success.json { render @user.as_json, status: :found }
    end
  end
end
