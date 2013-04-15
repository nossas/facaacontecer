module MyMoip
  class TransparentRecurringRequest < MyMoip::Request

    HTTP_METHOD   = :post
    PATH          = "/ws/alpha/EnviarInstrucao/Recorrente"
    REQUIRES_AUTH = true

    def api_call(data, opts = {})
      params = {
        body:          data.to_xml,
        http_method:   HTTP_METHOD,
        requires_auth: REQUIRES_AUTH,
        path:          PATH
      }

      super(params, opts)
    end

    def success?
      @response && @response["EnviarInstrucaoRecorrenteResponse"]["Resposta"]["Status"] == "Sucesso"
    rescue NoMethodError => e
      false
    end

    def token
      @response["EnviarInstrucaoRecorrenteResponse"]["Resposta"]["Token"] || nil
    rescue NoMethodError => e
      nil
    end

    def id
      @response["EnviarInstrucaoRecorrenteResponse"]["Resposta"]["ID"]
    rescue NoMethodError => e
      nil
    end

  end
end

