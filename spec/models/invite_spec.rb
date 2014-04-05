require 'spec_helper'

describe Invite do

  context "Associations & Validations" do
    it { should belong_to :user }
    it { should belong_to :host }
    it { should validate_presence_of :user_id }
  end

end
