MOIP_TOKEN  = ENV['MOIP_TOKEN'] 

#if Rails.env.real_production
#  MOIP_URL    = 'https://moip.com.br/assinaturas/v1'
#  MOIP_JS_URL = '//api.moip.com.br/moip-assinaturas.min.js'
#else
  MOIP_URL    = 'https://sandbox.moip.com.br/assinaturas/v1'
  MOIP_JS_URL = '//sandbox.moip.com.br/moip-assinaturas.min.js'
#end

