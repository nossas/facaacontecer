require 'spec_helper'

describe Project do
  context "associations" do
    it { should have_many(:orders) }
  end

  context "validations" do
    [:description, :expiration_date, 
     :title, :goal
    ].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end

  context "attributes" do
    [:description, :expiration_date, 
     :goal, :image, :title, :video
    ].each do |attribute|
      it { should allow_mass_assignment_of attribute }
    end
  end



  context "instance methods" do
    before do
      @project = stub_model(Project, save: true)
    end

    describe ".percent" do
      it "should calculates the percent based on #goal and #current" do
        @project.stub(:revenue).and_return(2.5)
        @project.stub(:goal).and_return(6.5)


        # 6.2/2.5 (current / goal)
        @project.percent.should == (2.5/6.5) * 100
      end
    end


    describe ".funded?" do
      it "should return true if the revenue is greater than the goal" do
        @project.stub(:percent).and_return(101)
        @project.funded?.should == true
      end
      it "should return false if the revenue is smaller than the goal" do
        @project.stub(:percent).and_return(99)
        @project.funded?.should == false
      end
    end

  end
end
