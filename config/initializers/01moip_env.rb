# ==============================
# Moip assinaturas configuration
# ==============================
MOIP_TOKEN              = ENV['MOIP_ASSINATURAS_TOKEN']

if Rails.env.production?
  MOIP_INSTRUCTION_URL  = "https://www.moip.com.br/Instrucao.do?token="
  MOIP_URL              = 'https://moip.com.br/assinaturas/v1'
  MOIP_JS_URL           = 'https://api.moip.com.br/moip-assinaturas.min.js'
else
  MOIP_INSTRUCTION_URL  = "https://desenvolvedor.moip.com.br/sandbox/Instrucao.do?token="
  MOIP_URL              = 'https://sandbox.moip.com.br/assinaturas/v1'
  MOIP_JS_URL           = 'https://sandbox.moip.com.br/moip-assinaturas.min.js'
end

# ======================
# MY MOIP Configuration
# ======================
environment             = Rails.env.production? ? 'production' : 'sandbox'

# Setting sandbox/production calling the methods based on environment switch
MyMoip.environment = environment
MyMoip.send("#{environment}_token=", ENV['MYMOIP_TOKEN'] || "test-token")
MyMoip.send("#{environment}_key=", ENV['MYMOIP_KEY'] || "test-key")


# ==================
# Notifications
# ================

MOIP_NOTIFICATIONS_HOST = ENV['NOTIFICATIONS_HOST'] || 'localhost'

require 'moip'
require 'moip/configuration'

Moip.configure do |config|
  config.token = ENV['MYMOIP_TOKEN']
  config.acount_key = ENV['MYMOIP_KEY']
  config.env = Rails.env.production? ? 'production' : 'sandbox'
end
