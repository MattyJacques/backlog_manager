# Pin npm packages by running ./bin/importmap

# Turbo/Stimulus
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true

# Bootstrap for CSS. JS and Turbolinks fight which breaks dropdowns, temp workaround in using CDN
pin '@popperjs/core', to: 'popper.js', preload: true
pin 'bootstrap', to: 'bootstrap.min.js', preload: true

# Application JS
pin 'application', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
