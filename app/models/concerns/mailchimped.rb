module Mailchimped
  extend ActiveSupport::Concern

  def remove_from_segment email, seg_id
    begin
      Gibbon::API.lists.static_segment_members_del(
      id: ENV["MAILCHIMP_LIST_ID"],
      seg_id: seg_id,
      batch: [{ email: email }]
      )
    rescue Exception => e
      Rails.logger.error e
    end
  end

  def add_to_segment email, seg_id
    begin
      Gibbon::API.lists.static_segment_members_add(
      id: ENV["MAILCHIMP_LIST_ID"],
      seg_id: seg_id,
      batch: [{ email: email }]
      )
    rescue Exception => e
      Rails.logger.error e
    end
  end
end
