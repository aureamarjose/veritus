import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["buttonPayment", "buttonEdit", "status"]
  static classes = ["disabled"]


  connect() {
    // console.log('addPayment_controller', this.statusTarget.value)
    this.toggleButton()
  }

  toggleButton() {
    let status = this.statusTarget.value

    if (status === 'true') {
      this.buttonPaymentTarget.disabled = true;
      this.buttonPaymentTarget.classList.add(...this.disabledClasses)
      this.buttonEditTarget.classList.add(...this.disabledClasses)
      this.buttonEditTarget.addEventListener("click", this.preventClick)
    }
  }

  preventClick(event) {
    event.preventDefault()
  }
}