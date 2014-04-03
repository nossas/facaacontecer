namespace :mailchimp do
  def create_segment name
    Gibbon::API.lists.segment_add(id: ENV["MAILCHIMP_LIST_ID"], opts: {type: "static", name: name})
  end

  def find_segment name
    segments = Gibbon::API.lists.segments(id: ENV["MAILCHIMP_LIST_ID"])
    segments["static"].select{|seg| seg["name"] == name}.first
  end

  def add_batch_to_segment batch, id
    Gibbon::API.lists.static_segment_members_add(id: ENV["MAILCHIMP_LIST_ID"], seg_id: id, batch: batch)
  end

  task :sync_funders_segment => :environment do
    name = "[Faça Acontecer] Todos os financiadores"
    create_segment name
    segment = find_segment name

    Payment.where("paid_at IS NOT NULL").find_in_batches do |payments|
      batch = payments.map{|p| {email: p.user.email}}
      add_batch_to_segment batch, segment[:id]
    end
  end
end
