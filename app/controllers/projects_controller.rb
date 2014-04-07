class ProjectsController < ApplicationController

  include ActionController::Caching::Actions
  # Setup invite when the param
  # is present
  before_filter { session[:invite] = params[:code] if params[:code] }
 
  caches_action :index, expires_in: 5.minutes

  before_actions do
    actions(:index) do
      # Querying only the first project, 
      # because we dont' have more than 1
      @project      = Project.first
    end

  end
  
  # GET /
  def index; end
end
