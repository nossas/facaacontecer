class ProjectsController < ApplicationController
  inherit_resources
  
  before_filter { @token = MOIP_TOKEN }
  before_filter { session[:invite] = params[:code] if params[:code] }

  def index
    @project      = Project.first
    @subscriber   = @project.subscribers.build
  end
end
