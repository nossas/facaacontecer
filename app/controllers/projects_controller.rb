class ProjectsController < ApplicationController
  inherit_resources
  
  before_filter { @token = MOIP_TOKEN }

  def index
    @project      = Project.first
    @subscriber   = @project.subscribers.build
  end
end
