MOIP_TOKEN  = ENV['MOIP_TOKEN'] 
MOIP_JS_URL = '//sandbox.moip.com.br/moip-assinaturas.min.js'
MOIP_JS_URL = '//api.moip.com.br/moip-assinaturas.min.js' if Rails.env.real_production?

