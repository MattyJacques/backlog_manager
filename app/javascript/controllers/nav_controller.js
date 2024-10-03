import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nav"
export default class extends Controller {
  static values = {
    url: String
  }

  goToUrl() {
    Turbo.visit(this.urlValue);
  }
}
