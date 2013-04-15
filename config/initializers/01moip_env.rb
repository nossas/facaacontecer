# Moip assinaturas configuration
MOIP_TOKEN  = ENV['MOIP_TOKEN'] 

if Rails.env.production?
  MOIP_INSTRUCTION_URL = "https://moip.com.br/Instrucao.do?token="  
  MOIP_URL    = 'https://moip.com.br/assinaturas/v1'
  MOIP_JS_URL = '//api.moip.com.br/moip-assinaturas.min.js'
else
  MOIP_INSTRUCTION_URL = "https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token="
  MOIP_URL    = 'https://sandbox.moip.com.br/assinaturas/v1'
  MOIP_JS_URL = '//sandbox.moip.com.br/moip-assinaturas.min.js'
end

# My Moip Configuration
MyMoip.environment = Rails.env.production? ? 'production' : 'sandbox'
MyMoip.token  = ENV['MYMOIP_TOKEN']
MyMoip.key    = ENV['MYMOIP_KEY']
