import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["inputDoc"]

    formatCPFOrCNPJ() {
        let value = this.inputDocTarget.value.replace(/\D/g, '')

        if (value.length <= 11) {
            value = value.replace(/(\d{3})(\d)/, "$1.$2")
            value = value.replace(/(\d{3})(\d)/, "$1.$2")
            value = value.replace(/(\d{3})(\d{1,2})$/, "$1-$2")
        } else {
            value = value.replace(/^(\d{2})(\d)/, "$1.$2")
            value = value.replace(/^(\d{2})\.(\d{3})(\d)/, "$1.$2.$3")
            value = value.replace(/\.(\d{3})(\d)/, ".$1/$2")
            value = value.replace(/(\d{4})(\d)/, "$1-$2")
        }

        this.inputDocTarget.value = value
    }
}