if Rails.env.test?
  ENV["MAILCHIMP_LIST_ID"] = "1"
end
