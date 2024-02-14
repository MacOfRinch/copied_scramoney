import { Controller } from "@hotwired/stimulus"

import { Modal } from "bootstrap"

// Connects to data-controller="modal"
export default class extends Controller {
  connect() {
    console.log('こんちは！');
    this.modal = new Modal(this.element);
    this.modal.show();
  }

  close(event) {
    if (event.detail.success) {
      this.modal.hide();
    }
  }

  closeAbsolutely() {
    this.modal.hide();
    window.location.reload();
  }

  closeAndReload(event) {
    if (event.detail.success) {
      this.modal.hide();
      location.reload();
    }
  }
}
