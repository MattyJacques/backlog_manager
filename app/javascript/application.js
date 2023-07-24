// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import '@hotwired/turbo-rails'
import "@popperjs/core";
import "bootstrap";
import 'controllers';

$(document).on('turbolinks:load', function() {
  $('.dropdown-toggle').dropdown()
})

import { Turbo } from "@hotwired/turbo-rails"
Turbo.session.drive = false
