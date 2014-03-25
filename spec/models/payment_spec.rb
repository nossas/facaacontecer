require 'spec_helper'

describe Payment do

  context "associations & validations" do
    it { should validate_presence_of :subscription }
    it { should belong_to :subscription } 
  end

end
