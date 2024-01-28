import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="record"
export default class extends Controller {
  static targets = [ "count" ]

  increment() {
    this.countTarget.value++;
  }

  decrement() {
    if (this.countTarget.value > 0) {
      this.countTarget.value--;
    }
  }
}
