class UsersController < ApplicationController
  inherit_resources
  
  def new
    @project = Project.find_by_id(params[:project_id])
    new!
  end
end
