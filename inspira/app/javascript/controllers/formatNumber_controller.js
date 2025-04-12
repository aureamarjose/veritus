import { Controller } from "@hotwired/stimulus"

export default class extends Controller {

    static targets = ["inputNumber"]

    format() {
        let value = this.inputNumberTarget.value.replace(/\D/g, '')

        this.inputNumberTarget.value = value
    }

}