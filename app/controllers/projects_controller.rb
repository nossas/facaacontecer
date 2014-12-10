class ProjectsController < ApplicationController

  # Setup invite when the param is present
  before_filter { session[:invite] = params[:code] if params[:code] }
 
  def index
    redirect_to Project.first
  end

  def show
    @project = Project.find params[:id]
  end
end
