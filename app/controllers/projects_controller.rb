class ProjectsController < ApplicationController
  inherit_resources

  def index
    @project = Project.first
  end
end
