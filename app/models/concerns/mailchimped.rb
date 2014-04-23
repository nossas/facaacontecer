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

  def add_to_subscription_segment email, status
    remove_from_segment email, ENV["MAILCHIMP_ACTIVE_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_SUSPENDED_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_OVERDUE_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_CANCELED_SEG_ID"]
    add_to_segment email, ENV["MAILCHIMP_#{status.upcase}_SEG_ID"]
  end

  def add_to_single_payment_segment email, status
    remove_from_segment email, ENV["MAILCHIMP_AUTHORIZED_PAYMENT_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_PRINTED_PAYMENT_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_FINISHED_PAYMENT_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_STARTED_PAYMENT_SEG_ID"]
    remove_from_segment email, ENV["MAILCHIMP_CANCELLED_PAYMENT_SEG_ID"]
    add_to_segment email, ENV["MAILCHIMP_#{status.upcase}_PAYMENT_SEG_ID"]
  end

  def update_user_data
    begin
      Gibbon::API.lists.subscribe(
        id: ENV["MAILCHIMP_LIST_ID"],
        email: { email: self.user.email },
        double_optin: false,
        update_existing: true,
        merge_vars: {
          PLAN: self.plan,
          POPTION: self.payment_option,
          NDONATIONS: self.successful_invoices.size,
          LDONATION: self.last_successful_invoice_date.try(:strftime, "%m/%d/%Y"),
          SUBUPDATED: self.state_updated_at.try(:strftime, "%m/%d/%Y"),
          VALUE: self.value
        }
      )
    rescue Exception => e
      Rails.logger.error e
    end
  end
end
