require 'spec_helper'

describe OrdersController do
  describe "#new" do
    before do
      @project = Project.make!
    end
    it "should return a new form for orders when a project_id is present" do
      get :new, project_id: @project.id
      response.should be_success
    end
  end
end
