# Model fabrication/fixtures

Fabricator(:user) do
  first_name        { "Juquinha" }
  last_name         { "Da Silva" }
  birthday          { "1988/11/12" }
  email             { "juquinha#{sn}@zip.net" }
  cpf               { CPF.generate }
  address_street    { "Rua Belisario Tavora 500" }
  address_extra     { "Laranjeiras" }
  address_number    { "100" }
  address_district  { "Laranjeiras" }
  city              { "Rio de Janeiro" }
  state             { "RJ" }
  country           { "BRA" }
  postal_code       { "78132-500" }
  phone             { "(21) 997137471" }
end


Fabricator(:project) do
  title           { "Meu projeto" }
  video           { "http://www.youtube.com/embed/Ej5rGGTHy54" }
  goal            { 25000 }
  description     { "Minha descricao" }
  expiration_date { Date.current + 45.days }
end