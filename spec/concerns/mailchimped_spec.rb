require 'spec_helper'

shared_examples_for "mailchimped" do
  let(:model) { described_class }

  describe("#remove_from_segment") do
    it "should remove the given email from the given segment" do
      mailchimped = Fabricate(model.to_s.underscore.to_sym)

      lists = double("lists")
      Gibbon::API.stub(:lists).and_return(lists)

      lists.should_receive(:static_segment_members_del).with(
      id: "1",
      seg_id: 1,
      batch: [{ email: "nicolas@trashmail.com" }]
      )

      mailchimped.remove_from_segment("nicolas@trashmail.com", 1)
    end
  end

  describe("#add_to_segment") do
    it "should add the given email from the given segment" do
      mailchimped = Fabricate(model.to_s.underscore.to_sym)

      lists = double("lists")
      Gibbon::API.stub(:lists).and_return(lists)

      lists.should_receive(:static_segment_members_add).with(
      id: "1",
      seg_id: 1,
      batch: [{ email: "nicolas@trashmail.com" }]
      )

      mailchimped.add_to_segment("nicolas@trashmail.com", 1)
    end
  end

  describe("#add_to_subscription_segment") do
    before { ENV["MAILCHIMP_ACTIVE_SEG_ID"] = "1" }
    before { ENV["MAILCHIMP_SUSPENDED_SEG_ID"] = "2" }
    before { ENV["MAILCHIMP_OVERDUE_SEG_ID"] = "3" }
    before { ENV["MAILCHIMP_CANCELED_SEG_ID"] = "4" }

    it "should remove the given email from all segments" do
      mailchimped = Fabricate(model.to_s.underscore.to_sym)
      mailchimped.should_receive(:remove_from_segment).with("nicolas@trashmail.com", "1")
      mailchimped.should_receive(:remove_from_segment).with("nicolas@trashmail.com", "2")
      mailchimped.should_receive(:remove_from_segment).with("nicolas@trashmail.com", "3")
      mailchimped.should_receive(:remove_from_segment).with("nicolas@trashmail.com", "4")
      mailchimped.add_to_subscription_segment("nicolas@trashmail.com", "active")
    end

    it "should add the given email to the given segment" do
      mailchimped = Fabricate(model.to_s.underscore.to_sym)
      mailchimped.should_receive(:add_to_segment).with("nicolas@trashmail.com", "1")
      mailchimped.add_to_subscription_segment("nicolas@trashmail.com", "active")
    end
  end
end
