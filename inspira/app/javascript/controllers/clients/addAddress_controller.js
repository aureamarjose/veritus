import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
    static targets = ["neighborhood", "street", "table", "template"]

    addAddress(event) {
        event.preventDefault();

        let neighborhood = this.neighborhoodTarget.value;
        let street = this.streetTarget.value;
        let row = this.templateTarget.content.cloneNode(true);

        row.querySelector('.neighborhood').textContent = neighborhood;
        row.querySelector('.street').textContent = street;
        row.querySelector('.neighborhood-input').value = neighborhood;
        row.querySelector('.street-input').value = street;

        this.tableTarget.appendChild(row);
        this.neighborhoodTarget.value = '';
        this.streetTarget.value = '';
    }

    deleteAddress(event) {
        event.preventDefault();

        let row = event.target.closest('tr');
        row.querySelector('.destroy-input').value = true;
        row.style.display = 'none';
    }

    editAddress(event) {
        event.preventDefault();

        this.deleteAddress(event);

        let row = event.target.closest('tr');
        let neighborhood = row.querySelector('.neighborhood').textContent;
        let street = row.querySelector('.street').textContent;

        this.neighborhoodTarget.value = neighborhood;
        this.streetTarget.value = street;
    }
}