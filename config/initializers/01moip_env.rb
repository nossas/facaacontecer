# ==============================
# Moip assinaturas configuration
# ==============================
MOIP_TOKEN  = ENV['MOIP_TOKEN'] 

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
MyMoip.send("#{environment}_token=", ENV['MYMOIP_TOKEN'])
MyMoip.send("#{environment}_key=", ENV['MYMOIP_KEY'])


# ==================
# Notifications
# ================

MOIP_NOTIFICATIONS_HOST = ENV['NOTIFICATIONS_HOST'] || 'localhost'
