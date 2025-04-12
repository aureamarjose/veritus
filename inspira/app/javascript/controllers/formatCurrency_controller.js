import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inputValue"]

  connect() {
    //console.log('formatCurrency_controller connected')

  }

  formatValue(event) {
    event.preventDefault()
    let value = this.inputValueTarget.value
    value = value.replace(/\D/g, '')

    let formattedValue = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value / 100);
    this.inputValueTarget.value = formattedValue
  }

}