import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["inputPhone"]

    formatPhone() {
        let value = this.inputPhoneTarget.value.replace(/\D/g, '')
        if (value.length <= 10) {
            value = value.replace(/(\d{2})(\d)/, "($1) $2")
            value = value.replace(/(\d{4})(\d)/, "$1-$2")
        } else {
            value = value.replace(/(\d{2})(\d)/, "($1) $2")
            value = value.replace(/(\(\d{2}\) \d)(\d)/, "$1 $2")
            value = value.replace(/(\d{4})(\d)/, "$1-$2")
        }

        this.inputPhoneTarget.value = value
    }
}