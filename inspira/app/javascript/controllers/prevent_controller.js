import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    connect() {
        //console.log('prevent_controller')
    }

    preventEnter(event) {
        if (event.key === 'Enter' || event.keyCode === 13) {
            event.preventDefault();
        }
    }

}