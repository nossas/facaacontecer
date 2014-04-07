# coding: utf-8
module ApplicationHelper


  def available_payment_banks
    [['Banco do Brasil', 'banco_do_brasil'], ['Bradesco', 'bradesco'], ['Itaú', 'itau'], ['Banrisul', 'banrisul']]
  end

  def available_payment_options
    [['Cartão de Crédito', 'creditcard'], ['Boleto', 'slip'], ['Débito Online', 'debit']]
  end


  def available_subscription_intervals
    [['Mensal', 'monthly'], ['Semestral', 'biannual'], ['Única', 'annual']]
  end

  def available_monthly_plans
    [['R$ 15', 15], ['R$ 30', 30], ['R$ 50', 50], ['R$ 100', 100]]
  end



  def available_biannual_plans
    [['R$ 90', 90], ['R$ 120', 120], ['R$ 180', 180], ['R$ 250', 250]]
  end


  def available_annual_plans
    [['R$ 180', 180], ['R$ 240', 240], ['R$ 360', 360], ['R$ 500', 500]]
  end

  def address_states
    [
      'AC',
      'AL',
      'AM',
      'AP',
      'BA',
      'CE',
      'DF',
      'ES',
      'GO',
      'MA',
      'MG',
      'MT',
      'PA',
      'PB',
      'PE',
      'PI',
      'PR',
      'RJ',
      'RN',
      'RO',
      'RR',
      'RS',
      'SC',
      'SE',
      'SP',
      'TO'
    ]
  end
end
