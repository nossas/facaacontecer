# coding: utf-8
module ApplicationHelper

  def available_plans
    # Value, Code in Moip
    [
      [9, '009'],
      [15,'015'],
      [17,'017'],
      [20,'020'],
      [50,'050'],
      [80,'080'],
      [100,'100'],
      [150,'150'],
      [250,'250']
    ]
  end


  def available_values
    [
      [12,'12.00'],
      [19,'19.00'],
      [35,'35.00'],
      [56,'56.00'],
      [80,'80.00'],
      [100,'100.00'],
      [150,'150.00'],
      [250,'250.00']
    ]    
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

  def initial_colaborators
    [
      'Adriana Teixeira Estellita Lins',
      'Alessandra Orofino Poubel',
      'Alexandre Warwar',
      'Alice Kasznar Feghali',
      'Alice Oliveira',
      'Alyne Rolin de Araujo',
      'Ana Luísa Corrêa da Costa Azêdo',
      'André Kano',
      'Anna Leticia Mariani Lacerda',
      'Arlindo Saraiva Pereira Junior',
      'Arminio Fraga Neto',
      'Arthur Aguillar',
      'Bernardo Castro',
      'Bruno Queiroz Cunha',
      'Cacá Neutzling',
      'Carlos Arthur Leite da Veiga',
      'Carlos Eduardo Lopes da Silva',
      'Carlos Sandes Ehlers',
      'Carolina de Moraes Rego Naine Reis',
      'Carolina Franco Afonso',
      'Clara Leitão Abreu',
      'Daniela Orofino',
      'Dirceu Barquette Filho',
      'Dorly Dias Curvello Neto',
      'Dulce Helena Gonçalves Orofino',
      'Edda S. de Freitas e Castro',
      'Eloisa Vidal Rosas',
      'Eurydice Botelho Moschkovich',
      'Fabiano de Souza Pereira',
      'Felipe Areas ',
      'Fernanda Whately',
      'Fernando Pinheiro da Silva',
      'George Leimann',
      'Gilberto Sayão da Silva',
      'Guilherme Augusto Frering ',
      'Heloisa Arruda',
      #'Icatu Holding S.A.',
      #'Instituto Arapyaú de Educação e Desenvolvimento Sustentável ',
      'Iracema Fanzeres Langsch Dutra',
      #'Itaú Unibanco S.A. ',
      'João de Lima Pessanha',
      'João Parodi',
      'John Raschle Junior',
      'José Antônio e Souza',
      'Julia Esteves Abreu',
      'Juliana de Souza Pedrosa',
      'Julio Cesar de Souza',
      'Kristina Michahelles',
      'Laura Uplinger',
      'Leila Jacyntho Dutra',
      'Leonardo do Carmo Alves',
      'Leonardo Elói',
      'Lucas Arantes Botelho Briglia Habib',
      'Lucia Helena Sampaio',
      'Luiz Fonseca',
      'Luiz Orenstein',
      'Manoel Corrêa do Lago',
      'Marcel Beiner',
      'Marcelo de Toledo Campanér',
      'Marcos Huet Nioac de Salles',
      'Maria Alcione Coelho',
      'Maria Elizabeth Pinto',
      'Maria Inês Carsalade Martins',
      'Mariana Moschkovich Athayde',
      'Miguel Lago',
      'Miriam de Andrade Levy',
      'Mônica Coelho Mitkiewicz',
      'Nicolas Iensen',
      'Nina Saroldi',
      'Octavio de Souza Dantas',
      'Orlando Hill',
      'Paulo Roberto Rodrigues de Souza',
      'Pedro Cavalcanti Ferreira',
      'Rafael Rezende',
      'Raul F. Carvalho Miranda',
      'Raulino Oliveira',
      'Rita Lamy Freund',
      'Rodrigo de Assis Fialho',
      'Rosalie Marin',
      'Rosangela Maciel de Araujo Passos',
      'Rubem Nunes Galvarro Vianna',
      'Sandra Lucia Correia Lima Fortes',
      'Tatiana Leite',
      'Thales Eduardo Soares Martins',
      'Valeska Gadelha',
      'Vicente Miller de Oliveira',
      'Vitor Gurgel de Medeiros',
      'Vitor Miranda ',
      'Vivian Moraes Alonso',
      'Viviane da Rocha Vieira',
      'Waldemar Falcão Neto',
      'Wilson Malafaia Peixoto',
      'Yasmin Youssef'
    ]
  end

  
  def facebook_share_invite_url
    "http://www.facebook.com/sharer.php?s=100&p[title]=Acabo de contribuir para a independência do Meu Rio.&p[summary]=Clique aqui e conheça as recompensas criativas que você e eu ganhamos por apoiar essa ideia e fazê-la acontecer.&p[url]=#{invite_url(code: @subscriber.invite.code)}&p[images][0]=#{image_path('og_image.jpg')}"
  end


  def facebook_share_common_url
    "https://www.facebook.com/sharer.php?s=100&p[title]=#{t('seo.og_title')}&p[summary]=#{t('seo.og_description')}&p[url]=#{root_url}&p[images][0]=#{image_path('fb_image.jpg')}"
  end


  def twitter_share_common_url
    "https://twitter.com/share?url=#{root_url}&text=#{t('seo.twitter_description')}"
  end
end
