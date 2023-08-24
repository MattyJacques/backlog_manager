import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="update-game-status"
export default class extends Controller {
  static targets = [ "form" ]

  update() {
    this.formTarget.requestSubmit()
  }
}
