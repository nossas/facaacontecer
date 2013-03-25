require 'spec_helper'

describe Invite do
  [:code, :parent_user_id, :user_id].each do |attr|
    it { should allow_mass_assignment_of attr }
  end

  it { should belong_to :user }
end
