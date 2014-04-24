def to_route string
  return retry_payment_path(@payment.id) if string == "this payment retry page"
  return subscription_path(@payment.subscription.id) if string == "this payment subscription page"
  raise "I don't know path '#{string}'"
end
