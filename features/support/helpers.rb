def to_route string
  return retry_payment_path(@payment.id) if string == "this payment retry page"
  return subscription_path(@payment.subscription.id) if string == "this payment subscription page"
  raise "I don't know path '#{string}'"
end

def to_element string
  return "a[href='#{retry_payment_path @payment.id}']" if string == "this payment retry link"
  raise "I don't know element '#{string}'"
end

def to_link string
  return "retry-link" if string == "this payment retry link"
  raise "I don't know element '#{string}'"
end
