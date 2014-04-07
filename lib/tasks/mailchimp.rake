OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

namespace :mailchimp do
  def create_segment name
    begin
      Gibbon::API.lists.segment_add(id: ENV["MAILCHIMP_LIST_ID"], opts: {type: "static", name: name})
    rescue Exception => e
      puts e.message
    end
  end

  def find_segment name
    segments = Gibbon::API.lists.segments(id: ENV["MAILCHIMP_LIST_ID"])
    segments["static"].select{|seg| seg["name"] == name}.first
  end

  def add_batch_to_segment payments, id
    batch = payments.map{|p| {email: p.user.email}}
    Gibbon::API.lists.static_segment_members_add(id: ENV["MAILCHIMP_LIST_ID"], seg_id: id, batch: batch)
  end

  task :sync_funders_segment => :environment do
    name = "[Faça Acontecer] Todos os financiadores"
    create_segment name
    segment = find_segment name

    Payment.where("paid_at IS NOT NULL").find_in_batches do |payments|
      add_batch_to_segment payments, segment["id"]
    end
  end

  task :sync_month_funders_segment => :environment do
    name = "[Faça Acontecer] Financiadores de #{Date.today.strftime("%m/%Y")}"
    create_segment name
    segment = find_segment name

    Payment.where("EXTRACT(month FROM paid_at) = ?", Date.today.month).find_in_batches do |payments|
      add_batch_to_segment payments, segment["id"]
    end
  end

  task :sync_month_tryers_segment => :environment do
    name = "[Faça Acontecer] Tentadores de #{Date.today.strftime("%m/%Y")}"
    create_segment name
    segment = find_segment name

    Payment.where("EXTRACT(month FROM created_at) = ? AND state <> 'finished'", Date.today.month).find_in_batches do |payments|
      add_batch_to_segment payments, segment["id"]
    end
  end
end
