# Faça Acontecer
A selfstarter based project

[![Build Status](https://travis-ci.org/meurio/selfstarter.png?branch=master)](https://travis-ci.org/meurio/facaacontecer)
[![Code Climate](https://codeclimate.com/github/meurio/facaacontecer.png)](https://codeclimate.com/github/meurio/facaacontecer)
[![Coverage Status](https://coveralls.io/repos/meurio/facaacontecer/badge.png?branch=master)](https://coveralls.io/r/meurio/facaacontecer)


## This project

- Couldn't be possible without the guys from [Selfstarter](https://github.com/lockitron/selfstarter). 
- The origin was preserved (including the name of the app, git commits), but with huge adaptations for the Brazilian reality.
- Is heavilly dependent on Moip Assinaturas. Go check at: http://site.moip.com.br/assinaturas/
- It's in English. Universal language, you know.

## What do you need to run?

- Ruby 1.9.3+ I'll migrate it to ruby 2.0 soon, so don't expect 1.9.3 support in future releases.
- Rails 3.2.13 or greater. Note that a Rails 4.0 update is planned, so things will break for sure. And don't expect support for 3.2.13 in the future.
- Always keep your code updated, because I'll only move forward.
- SQLite for development, for now. But in the future, the schema will be plain and good SQL for postgres.
- Linux. You'll have a headache using windows. Trust me.


## Initial Roadmap

### Highest
- Improve tests. We have a slow coverage now (only 76%).
- Cucumber specs, to check the form
- Jasmine specs, to check javascripts
- An admin to create Project or Projects.

### Minor
- A way to get webhooks from moip after order submits.
- An admin/dashboard to check current progress, social engagement and clicks.
- Improve form, because hidden labels can lead to misinterpretation.

## Thanks
- The guys and inspiration from [Selfstarter](https://selfstarter.us).
- The inspiration from [Catarse](http://catarse.me)

## License

Check LICENSE file.
