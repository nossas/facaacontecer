# Faça Acontecer
A selfstarter based project

[![Build Status](https://travis-ci.org/meurio/facaacontecer.png?branch=master)](https://travis-ci.org/meurio/facaacontecer)
[![Code Climate](https://codeclimate.com/github/meurio/facaacontecer.png)](https://codeclimate.com/github/meurio/facaacontecer)


## Este projeto

- Livremente inspirado pelo [Selfstarter](https://github.com/lockitron/selfstarter). 
- Os commits iniciais do Selfstarter foram preservados.
- Depende do MoIP Assinaturas, veja: http://site.moip.com.br/assinaturas/
- Depende da Gem MYMOIP.
- Fora o README, está tudo em inglês.

## Rodando o projeto

- Ruby 2.1.0, não há suporte para versões anteriores.
- PostgreSQL. Você precisa ter instalado na sua máquina
- Rails 4.0.3 ou superior.
- Firefox, pra rodar os testes de integração.
- APIs do MoIP (`http://sandbox.moip.com.br`)

## Organização

Pra evitar muita complexidade desnecessária, o código na aplicação foi "decoupled" em várias partes menores reaproveitáveis, graças ao uso constante de Concerns.

- `App/business` - é onde se concentra toda a lógica de negócios dos modelos. 3rd-party APIs, calculos, etc. devem ficar aqui. E são isolados em methods dentro dos modelos (facilitando o teste).
- `App/observers` - é onde se concentra toda a lógica que acompanha callbacks. Se você precisa fazer uma ação after_create, before_validation, before_*; é aqui que deve ficar.
- `App/workers` - é onde se concentram os workers, que utilizando o Sidekiq, operam de forma assincrona e em conjunto com os `Observers`. (praticamente todo callback é child de um observer - exceto os de notificação)
- `App/scopes`  - é onde ficam concentrados os scopes dos modelos. Pra evitar que o modelo ficasse ilegível, foi optado pela separação.
- `App/states`  - é onde ficam as definições de estado. Utilizando `state_machine`, objetos são transicionados de um estado para o outro.
- `App/validators` - o nome já diz o suficiente. Coloque os validators personalizados aqui; não no modelo.

## Pull requests

São muito bem vindas. Crie testes e é só enviar :)


## Fork

Você é livre pra fazer o que quiser com o código. Desde que cite a origem (este repositório) ou até mesmo mande um email dizendo "ei galera, to usando!".


## Thanks
- The guys and inspiration from [Selfstarter](https://selfstarter.us).
- The inspiration from [Catarse](http://catarse.me)

## License

Check LICENSE file.
