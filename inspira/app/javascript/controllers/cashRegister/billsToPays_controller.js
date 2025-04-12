import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['inputPayDay', "inputStatus", "blockPayDay"]
  static values = {
    status: Boolean,
  }

  connect() {
    this.initializeStatus()
    this.toggleStatus()

    // Re-inicializa após renderizações do Turbo
    document.addEventListener("turbo:render", () => {
      this.initializeStatus()
      this.toggleStatus()
    })
  }

  initializeStatus() {
    this.statusValue = this.inputStatusTarget.value === "true"
  }

  toggleStatus(event) {
    const status = event ? event.target.value === "true" : this.statusValue

    if (status === true) {
      this.blockPayDayTarget.classList.remove('hidden')
    } else {
      this.blockPayDayTarget.classList.add('hidden')
      this.inputPayDayTarget.value = null
    }
  }
}