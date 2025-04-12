import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['formAccountPayable', 'formRecurringPayableAccount', "inputType"]
  static_values = {
    status: Boolean,
  }

  connect() {
    //console.log('form_control_controller')
    this.statusValue = false // Define o valor inicial de status como false
    this.updateFormVisibility()
  }

  toggleStatus(event) {
    this.statusValue = event.target.checked
    this.updateFormVisibility()
  }

  updateFormVisibility() {
    if (this.statusValue) {
      this.formAccountPayableTarget.classList.add('hidden')
      this.formRecurringPayableAccountTarget.classList.remove('hidden')
    } else {
      this.formAccountPayableTarget.classList.remove('hidden')
      this.formRecurringPayableAccountTarget.classList.add('hidden')
    }
  }
}