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

  def update_user_data options
    merge_vars = {
      PLAN:       options[:plan],
      SUBUPDATED: options[:state_updated_at],
      SUBVALUE:   options[:subscription_value],
      LINVOICE:   options[:last_invoice].try(:strftime, "%m/%d/%Y"),
      NINVOICES:  options[:invoices_count],
      RETRYLINK:  options[:retry_link],
      NPAYMENTS:  options[:payments_count],
      LPAYMENT:   options[:last_payment_created_at].try(:strftime, "%m/%d/%Y"),
      PAYVALUE:   options[:payment_value],
      PAYOPTION:  options[:payment_option],
      groupings: [ name: 'Doador', groups: options[:organizations] ]
    }

    begin
      Gibbon::API.lists.subscribe(
        id: ENV["MAILCHIMP_LIST_ID"],
        email: { email: self.user.email },
        double_optin: false,
        update_existing: true,
        merge_vars: merge_vars
      )
    rescue Exception => e
      Rails.logger.error e
    end
  end
end
