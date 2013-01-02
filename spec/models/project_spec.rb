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
end
