import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'


export default class extends Controller {
    static outlets = ["services--services", "services--additionalCharge", "services--received", "services--generalData"]
    static targets = ["toReceive", "debit", "textDebit", "results"]
    static debounces = ["calcReceived", "calcDebit"]
    static classes = ["classcss", "classcssdanger", "classcsshidden"]

    connect() {
        useDebounce(this, { wait: 500 })
        //console.log("Results controller connected");
        this.calcReceived()

    }

    calcReceived() {
        let total = 0

        let serviceTotal = this.servicesServicesOutlet.serviceTotalTarget
        let totalCost = this.servicesAdditionalChargeOutlet.totalCostTarget

        serviceTotal = this.formatNumber(serviceTotal)

        totalCost = this.formatNumber(totalCost)

        total = serviceTotal + totalCost

        this.toReceiveTarget.textContent = this.formatCurrency(total)

        this.calcDebit()
    }

    calcDebit() {
        let total = 0

        let received = this.servicesReceivedOutlet.totalReceivedTarget
        let toReceive = this.toReceiveTarget

        received = this.formatNumber(received)
        toReceive = this.formatNumber(toReceive)
        total = toReceive - received

        if (total < 0) {
            this.debitTarget.textContent = this.formatCurrency(Math.abs(total))
            this.textDebitTarget.textContent = "Saldo:"
            this.servicesGeneralDataOutlet.inputFinancialSituationTarget.value = "Aberto"
            this.addClassBalance()

        } else if (total > 0) {
            this.debitTarget.textContent = this.formatCurrency(Math.abs(total))
            this.textDebitTarget.textContent = "Débito:"
            this.servicesGeneralDataOutlet.inputFinancialSituationTarget.value = "Aberto"
            this.addClassDebit()
        } else if (total === 0 && received > 0 || total === 0 && toReceive > 0) {
            this.resultsTarget.classList.add(this.classcsshiddenClass)
            this.servicesGeneralDataOutlet.inputFinancialSituationTarget.value = "Quitado"
        } else {
            this.servicesGeneralDataOutlet.inputFinancialSituationTarget.value = ""
            this.resultsTarget.classList.add(this.classcsshiddenClass)
        }
    }

    formatNumber(number) {
        number = number.textContent
        number = number.replace(/\D/g, '')  // Remove caracteres não numéricos        
        return number = number === "" ? 0 : parseFloat(number) / 100; // Dividir por 100 para considerar centavos
    }

    formatCurrency(number) {
        return new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(number);
    }

    addClassBalance() {
        this.debitTarget.classList.remove(this.classcssdangerClass)
        this.textDebitTarget.classList.remove(this.classcssdangerClass)
        this.debitTarget.classList.add(this.classcssClass)
        this.textDebitTarget.classList.add(this.classcssClass)
        this.resultsTarget.classList.remove(this.classcsshiddenClass)
    }

    addClassDebit() {
        this.debitTarget.classList.remove(this.classcssClass)
        this.textDebitTarget.classList.remove(this.classcssClass)
        this.debitTarget.classList.add(this.classcssdangerClass)
        this.textDebitTarget.classList.add(this.classcssdangerClass)
        this.resultsTarget.classList.remove(this.classcsshiddenClass)
    }
}