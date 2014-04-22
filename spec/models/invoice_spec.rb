require 'spec_helper'

describe Invoice do
  before { Fabricate(:invoice) }

  it { should validate_presence_of :uid }
  it { should validate_presence_of :subscription_id }
  it { should validate_presence_of :value }
  it { should validate_presence_of :occurrence }
  it { should validate_presence_of :status }
  it { should validate_uniqueness_of :uid }
end
