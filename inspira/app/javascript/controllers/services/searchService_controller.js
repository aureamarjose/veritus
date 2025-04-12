import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'


export default class extends Controller {
    static debounces = ["search"]
    static targets = ["inputFolder", "inputNameContractor", "inputClientName", "inputStreet", "inputFinancialSituation", "inputProgress"]

    connect() {
        useDebounce(this, { wait: 1000 })
    }

    search(event) {
        event.preventDefault(); // Impede o comportamento padrão de submissão do formulário
        this.element.requestSubmit()
    }

    format() {
        let value = this.inputFolderTarget.value.replace(/\D/g, '');

        // Remove zeros iniciais, exceto se o número for apenas '0'
        value = value.replace(/^0+/, '');

        this.inputFolderTarget.value = value;
    }
}