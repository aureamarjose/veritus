import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "radio"]

  connect() {
    //  console.log('clear_controller', this.inputTargets.value)
  }

  clearInput() {

    this.inputTargets.forEach((input) => {
      input.value = ""
    })

    this.radioTargets.forEach(radio => {
      radio.checked = false
    })
  }

}