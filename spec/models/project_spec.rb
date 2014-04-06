require 'spec_helper'

describe Project do
  context "associations" do
    it { should have_many(:subscriptions) }
    it { should have_many(:users) }
  end

  context "validations" do
    [:description, :title].each do |attribute|
      it { should validate_presence_of attribute }
    end
  end

end
