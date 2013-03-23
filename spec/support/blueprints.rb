require 'machinist/active_record'


User.blueprint do
  name        { "Juquinha da silva" }
  birthday    { "1988/11/12" }
  email       { "juquinha@zip.net" }
  cpf         { "11144477735" }
  address_street { "Rua Belisario Tavora 500" }
  address_extra { "Laranjeiras" }
  address_number { "100" }
  address_district { "Laranjeiras" }
  city       { "Rio de Janeiro" }
  state       { "RJ" }
  country     { "BRA" }
  zipcode { "78132-500" }
  phone       { "(21) 97137471" }
end

Subscription.blueprint do
  value       { 10 }
  code        { "TOKEN" }
  project     { Project.make! }
  subscriber  { User.make! }
  anonymous   { false }
  gift        { true }
end


Project.blueprint do
  title { "Meu projeto" }
  video { "http://www.youtube.com/embed/Ej5rGGTHy54" }
  goal  { 25000 }
  description     { "Minha descricao" }
  expiration_date { Time.now + 45.days }
end
