class ProjectsController < ApplicationController

  before_filter { @token = MOIP_TOKEN }
  before_filter { session[:invite] = params[:code] if params[:code] }
  
  before_actions do
    actions(:index) do
      # Querying only the first project, because we dont' have more than 1
      @project      = Project.first
    end

  end
  

  def index; end
end
