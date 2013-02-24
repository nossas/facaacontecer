require 'machinist/active_record'


User.blueprint do
  name        { "Juquinha da silva" }
  birthday    { "1988/11/12" }
  email       { "juquinha@zip.net" }
  cpf         { "12312312312" }
  address_street { "Rua Belisario Tavora 500" }
  address_street_extra { "Laranjeiras" }
  address_street_number { "100" }
  address_neighbourhood { "Laranjeiras" }
  address_city        { "Rio de Janeiro" }
  address_state       { "RJ" }
  address_country     { "BRA" }
  address_cep         { "78132-500" }
  address_phone       { "(21) 97137471" }
end

Subscription.blueprint do
  value       { 10 }
  status      { nil }
  token       { "TOKEN" }
  project     { Project.make! }
  user        { User.make! }
end


Project.blueprint do
  title { "Meu projeto" }
  video { "http://www.youtube.com/embed/Ej5rGGTHy54" }
  goal  { 25000 }
  description     { "Minha descricao" }
  expiration_date { Time.now + 45.days }
end
