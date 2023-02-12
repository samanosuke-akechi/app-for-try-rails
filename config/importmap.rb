# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'jquery_init'
pin 'try_slick'
pin 'sortable'

# Library and Plugin
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.1/dist/jquery.js'
pin 'slick-carousel', to: 'https://ga.jspm.io/npm:slick-carousel@1.8.1/slick/slick.js'
pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'stimulus-rails-nested-form', to: 'https://ga.jspm.io/npm:stimulus-rails-nested-form@4.0.0/dist/stimulus-rails-nested-form.es.js'
pin '@rails/activestorage', to: 'https://ga.jspm.io/npm:@rails/activestorage@7.0.4-2/app/assets/javascripts/activestorage.esm.js'
pin 'trix'
pin '@rails/actiontext', to: 'actiontext.js'
