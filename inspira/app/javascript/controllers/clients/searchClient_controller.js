import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'


export default class extends Controller {
    static debounces = ["searchClient"]
    connect() {
        useDebounce(this, { wait: 500 })
    }

    searchClient() {
        this.element.requestSubmit()
    }
}