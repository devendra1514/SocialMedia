import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    // Get the query parameters
    const urlParams = new URLSearchParams(window.location.search);

    // Extract the 'msg' parameter
    const message = urlParams.get('msg');
    // If there's a message, display it, otherwise show default text
    if (message) {
      this.messageTarget.textContent = message;
    } else {
      this.messageTarget.textContent = "No message found.";
    }
  }
}
