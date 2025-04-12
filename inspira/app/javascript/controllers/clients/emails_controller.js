import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["fields", "template"]

    add_association(event) {
        event.preventDefault()
        let content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime())
        this.fieldsTarget.insertAdjacentHTML('beforeend', content)
    }

    remove_association(event) {
        event.preventDefault()
        let wrapper = event.target.closest('.nested-fields')
        if (wrapper.dataset.newRecord == 'true') {
            wrapper.remove()
        } else {
            wrapper.querySelector("input[name*='_destroy']").value = '1'
            wrapper.classList.add('hidden');
        }
    }
}