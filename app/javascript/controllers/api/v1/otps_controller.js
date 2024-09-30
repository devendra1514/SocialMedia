import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["phoneInput", "errorMessage", "submitButton", "loader"]

  sendOtp(event) {
    event.preventDefault();
    
    const phoneNumber = this.phoneInputTarget.value.trim();

    if (phoneNumber === "") {
      this.showMessage('Enter phone number');
      return;
    }

    // Show loader and disable submit button while making request
    this.loaderTarget.style.display = 'inline-block';
    this.submitButtonTarget.disabled = true;

    fetch("/api/v1/otp", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ full_phone_number: phoneNumber, purpose: "forgot_password" })
    })
    .then(response => {
      if (response.status === 404) {
        return response.json().then(body => {
          this.showMessage(body.error);
        });
      } else if (response.status === 422) {
        return response.json().then(body => {
          this.showMessage(body.error);
        });
      } else if (response.status === 201) {
        return response.json().then(body => {
          // this.showMessage(body.message);
          const phoneNumber = encodeURIComponent(phoneNumber);
          const msg = encodeURIComponent('Otp send successfully');
          window.location.href = `/api/v1/password/new?phone_number=${phoneNumber}&msg=${msg}`;
        });
      }
    })
    .catch(error => {
      console.error("Error occurred:", error);
      this.showMessage("An unexpected error occurred. Please try again.");
    })
    .finally(() => {
      this.loaderTarget.style.display = 'none';
      this.submitButtonTarget.disabled = false;
    });
  }

  showMessage(msg) {
    this.errorMessageTarget.textContent = msg.toString();
    this.errorMessageTarget.style.display = 'block';
  }
}
