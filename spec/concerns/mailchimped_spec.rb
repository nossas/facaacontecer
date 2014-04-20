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
end
