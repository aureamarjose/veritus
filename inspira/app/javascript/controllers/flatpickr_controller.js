import { Controller } from "@hotwired/stimulus"
import flatpickr from "flatpickr"

export default class extends Controller {
  static targets = ["inputDateRange", "inputDate"]

  connect() {
    //console.log('Flatpickr connected')
    this.initializeFlatpickr()
    // Listener para eventos Turbo
    document.addEventListener("turbo:render", this.initializeFlatpickr.bind(this))
  }

  disconnect() {
    // Remover o listener quando o controlador é desconectado
    document.removeEventListener("turbo:render", this.initializeFlatpickr.bind(this))
  }

  initializeFlatpickr() {
    this.inputDateRangeTargets.forEach((inputDate) => {
      flatpickr(inputDate, {
        dateFormat: "d/m/Y",
        mode: "range",
      });
    });

    this.inputDateTargets.forEach((inputDate) => {
      flatpickr(inputDate, {
        dateFormat: "d/m/Y",
        allowInput: true,
      });
    });
  }

}