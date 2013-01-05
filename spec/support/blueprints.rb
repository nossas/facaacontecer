require 'machinist/active_record'


Order.blueprint do
  name        { "Juquinha da silva" }
  birthday    { "1988/11/12" }
  email       { "juquinha@zip.net" }
  cpf         { "12312312312" }
  address_one { "Rua Belisario Tavora 500" }
  address_two { "Laranjeiras" }
  address_number { "100" }
  address_neighbourhood { "Laranjeiras" }
  city        { "Rio de Janeiro" }
  state       { "RJ" }
  country     { "BRA" }
  zip         { "22245060" }
  phone       { "2197137471" }
  value       { 10 }
  status      { nil }
  token       { "TOKEN" }
  project     { Project.make! }
end


Project.blueprint do
  title { "Meu projeto" }
  video { "http://www.youtube.com/embed/Ej5rGGTHy54" }
  goal  { 25000 }
  description     { "Minha descricao" }
  expiration_date { Time.now + 45.days }
end

# Add your blueprints here.
#
# e.g.
#   Post.blueprint do
#     title { "Post #{sn}" }
#     body  { "Lorem ipsum..." }
#   end
