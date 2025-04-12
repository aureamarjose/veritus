import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inputRangeDateExpiration", "inputRangeDatePayment", "inputCategory", "inputSituation", "inputAccountTypeName"]

  connect() {
    // console.log('filter_controller')
  }

  dateExpiration() {
    let inputRangeDateExpiration = this.inputRangeDateExpirationTarget.value

    if (inputRangeDateExpiration !== "") {
      this.inputRangeDatePaymentTarget.disabled = true
    }
  }

  datePayment() {
    let inputRangeDatePayment = this.inputRangeDatePaymentTarget.value

    if (inputRangeDatePayment !== "") {
      this.inputRangeDateExpirationTarget.disabled = true
    }
  }

  selectCategory() {
    let inputCategory = this.inputCategoryTarget.value

    if (inputCategory !== "") {
      this.inputAccountTypeNameTarget.disabled = true
    }
  }

  accountTypeName() {
    let inputAccountTypeName = this.inputAccountTypeNameTarget.value

    if (inputAccountTypeName !== "") {
      this.inputCategoryTarget.disabled = true
    }
  }

  clearInputs() {
    this.inputRangeDateExpirationTarget.value = ""
    this.inputRangeDatePaymentTarget.value = ""
    this.inputCategoryTarget.value = ""
    this.inputSituationTarget.value = ""
    this.inputAccountTypeNameTarget.value = ""
    this.inputRangeDatePaymentTarget.disabled = false
    this.inputRangeDateExpirationTarget.disabled = false
    this.inputAccountTypeNameTarget.disabled = false
    this.inputCategoryTarget.disabled = false
  }
}