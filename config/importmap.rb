# Pin npm packages by running ./bin/importmap

pin 'application', preload: true
pin 'jquery_init'
pin 'try_slick'
pin 'sortable'

# Library and Plugin
pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.1/dist/jquery.js'
pin 'slick-carousel', to: 'https://ga.jspm.io/npm:slick-carousel@1.8.1/slick/slick.js'
pin 'sortablejs', to: 'https://ga.jspm.io/npm:sortablejs@1.15.0/modular/sortable.esm.js'
