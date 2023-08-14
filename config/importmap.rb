# Pin npm packages by running ./bin/importmap

# Turbo/Stimulus
pin '@hotwired/turbo-rails', to: 'turbo.min.js', preload: true
pin '@hotwired/stimulus', to: 'stimulus.min.js', preload: true
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js', preload: true

# Bootstrap JS
pin '@popperjs/core', to: 'popperjs-2.11.8/popper.min.js'
pin 'bootstrap', to: 'bootstrap-5.3.1/bootstrap.min.js'

# Application JS
pin 'application', preload: true
pin_all_from 'app/javascript/controllers', under: 'controllers'
