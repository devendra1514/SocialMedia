import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["phoneInput", "otpInput", "passwordInput", "passwordConfirmationInput", "errorMessage", "submitButton", "loader", "message"]

  connect() {
    const urlParams = new URLSearchParams(window.location.search);
    const phoneNumber = urlParams.get('phone_number');
    const message = urlParams.get('msg');

    if (phoneNumber) {
      this.phoneInputTarget.value = phoneNumber;
    } else {
      window.location.href = "/?msg=Not valid request";
    }

    if (message) {
      this.messageTarget.textContent = message;
      this.messageTarget.style.display = 'block';
    } else {
      window.location.href = "/?msg=Not valid request";
    }
  }

  updatePassword(event) {
    event.preventDefault();
    
    const phoneNumber = this.phoneInputTarget.value.trim();
    const otp = this.otpInputTarget.value.trim();
    const password = this.passwordInputTarget.value;
    const passwordConfirmation = this.passwordConfirmationInputTarget.value;

    if (!otp || !password || !passwordConfirmation) {
      this.showMessage('All fields are required.');
      return;
    }

    if (password !== passwordConfirmation) {
      this.showMessage('Passwords do not match.');
      return;
    }

    this.loaderTarget.style.display = 'inline-block';
    this.submitButtonTarget.disabled = true;

    fetch("/api/v1/password", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        full_phone_number: phoneNumber,
        code: otp,
        password: password,
        password_confirmation: passwordConfirmation
      })
    })
    .then(response => {
      if (response.ok) {
        return response.json().then(body => {
          this.showMessage(body.message, "success");
        });
      } else {
        return response.json().then(body => {
          this.showMessage(body.error, "error");
        });
      }
    })
    .catch(error => {
      console.error("Error occurred:", error);
      this.showMessage("An unexpected error occurred. Please try again.", "error");
    })
    .finally(() => {
      // Hide loader and re-enable the submit button after request completes
      this.loaderTarget.style.display = 'none';
      this.submitButtonTarget.disabled = false;
    });
  }

  showMessage(msg, type = "error") {
    const errorMessageElement = this.errorMessageTarget;
    errorMessageElement.textContent = msg;
    errorMessageElement.style.display = 'block';
    errorMessageElement.className = `alert alert-${type === "success" ? "success" : "danger"} error-message`;

    if (type === "success") {
      window.location.href = "/?msg=Password updated successfully";
    }
  }
}
