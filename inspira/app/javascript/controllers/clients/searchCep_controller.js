import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inputCep", "neighborhood", "street", "cep", "complement", "city", "uf", "add_number", "table", "template", "message", "fields", "destroyInput"]

  connect() {
    this.toCheck()
  }

  formatCep() {
    let value = this.inputCepTarget.value.replace(/\D/g, '')

    if (value.length <= 11) {
      value = value.replace(/(\d{5})(\d)/, "$1-$2")
    }
    this.inputCepTarget.value = value
  }

  searchCep() {
    let cep = this.inputCepTarget.value

    if (cep.length < 9) {
      this.messageSearchCep('CEP inválido, deve conter 9 dígitos!')
      return
    }

    const url = `https://viacep.com.br/ws/${cep}/json/`

    fetch(`${url}`)
      .then(response => response.json())
      .then(data => {
        if (data.erro) {
          this.messageSearchCep('CEP não encontrado!')
          return
        }
        this.streetTarget.value = data.logradouro
        this.neighborhoodTarget.value = data.bairro
        this.cityTarget.value = data.localidade
        this.cepTarget.value = data.cep
        this.ufTarget.value = data.uf
        this.complementTarget.value = data.complemento
      })
    this.inputCepTarget.value = ''
  }

  messageSearchCep(message) {
    Toastify({
      text: message,
      duration: 3000,
      style: {
        background: "red",
      }
    }).showToast();
  }

  addAddress(event) {
    event.preventDefault();

    if (this.validateFields() > 0) {
      return;
    }

    let neighborhood = this.neighborhoodTarget.value;
    let street = this.streetTarget.value;
    let city = this.cityTarget.value;
    let cep = this.cepTarget.value;
    let add_number = this.add_numberTarget.value;
    let uf = this.ufTarget.value;
    let complement = this.complementTarget.value;

    let row = this.templateTarget.content.cloneNode(true);

    row.querySelector('.neighborhood').textContent = neighborhood;
    row.querySelector('.street').textContent = street;
    row.querySelector('.city').textContent = city;
    row.querySelector('.cep').textContent = cep;
    row.querySelector('.number').textContent = add_number;
    row.querySelector('.uf').textContent = uf;
    row.querySelector('.complement').textContent = complement;

    row.querySelector('.neighborhood-input').value = neighborhood;
    row.querySelector('.street-input').value = street;
    row.querySelector('.city-input').value = city;
    row.querySelector('.cep-input').value = cep;
    row.querySelector('.number-input').value = add_number;
    row.querySelector('.uf-input').value = uf;
    row.querySelector('.complement-input').value = complement;

    this.tableTarget.appendChild(row);
    this.neighborhoodTarget.value = '';
    this.streetTarget.value = '';
    this.cityTarget.value = '';
    this.cepTarget.value = '';
    this.add_numberTarget.value = '';
    this.ufTarget.value = '';
    this.complementTarget.value = '';

    this.toCheck()
  }

  deleteAddress(event) {
    event.preventDefault();

    let row = event.target.closest('tr');
    let destroyInput = row.querySelector('.destroy-input');

    if (destroyInput) {
      // Se o endereço já foi salvo, marque-o para exclusão
      destroyInput.value = true;
      row.classList.add('hidden');
    } else {
      // Se o endereço ainda não foi salvo, remova a linha inteira
      row.remove();
    }

    this.toCheck()
  }

  editAddress(event) {
    event.preventDefault();

    let row = event.target.closest('tr');

    let neighborhood = row.querySelector('.neighborhood');
    let street = row.querySelector('.street');
    let city = row.querySelector('.city');
    let cep = row.querySelector('.cep');
    let add_number = row.querySelector('.number');
    let uf = row.querySelector('.uf');
    let complement = row.querySelector('.complement');

    this.deleteAddress(event);

    this.neighborhoodTarget.value = neighborhood.textContent;
    this.streetTarget.value = street.textContent;
    this.cityTarget.value = city.textContent;
    this.cepTarget.value = cep.textContent;
    this.add_numberTarget.value = add_number.textContent;
    this.ufTarget.value = uf.textContent;
    this.complementTarget.value = complement.textContent;
  }

  toCheck() {
    let rows = this.tableTarget.querySelectorAll('tr');

    let visibleRows = Array.from(rows).filter(row => window.getComputedStyle(row).display !== 'none');

    if (visibleRows.length <= 1) {
      // O campo está vazio
      this.tableTarget.classList.add('hidden');
      this.messageTarget.classList.remove('hidden');
    } else {
      this.tableTarget.classList.remove('hidden');
      this.messageTarget.classList.add('hidden');
    }
  }


  validateFields() {
    let fields = [this.streetTarget, this.neighborhoodTarget, this.cityTarget, this.cepTarget, this.add_numberTarget, this.ufTarget]
    let fieldNames = []

    for (let field of fields) {
      if (!field.value) {
        switch (field) {
          case this.streetTarget:
            fieldNames.push(window.translations.streetRequired)
            break
          case this.neighborhoodTarget:
            fieldNames.push(window.translations.neighborhoodRequired)
            break
          case this.cityTarget:
            fieldNames.push(window.translations.cityRequired)
            break
          case this.cepTarget:
            fieldNames.push(window.translations.cepRequired)
            break
          case this.add_numberTarget:
            fieldNames.push(window.translations.numberRequired)
            break
          case this.ufTarget:
            fieldNames.push(window.translations.ufRequired)
            break
        }

      }
    }

    let listHTML = '';
    for (let fieldName of fieldNames) {
      listHTML += `<li>${fieldName}</li>`;
    }

    let template = document.querySelector('[data-clients--searchCep-target="fields"]');
    let clone = document.importNode(template.content, true);
    let alertElement = clone.querySelector('ul');
    alertElement.innerHTML = listHTML;

    // Insira o clone no DOM em um local apropriado
    let parentElement = document.querySelector('#myElement');

    // Remova o clone existente, se houver
    let renderedTemplate = document.querySelector('#myCloneId');
    if (renderedTemplate) {
      renderedTemplate.remove();
    }

    // Adicione um ID ao elemento div dentro do clone
    let divElement = clone.querySelector('div.flex');
    divElement.id = 'myCloneId';

    if (fieldNames.length !== 0) {
      parentElement.appendChild(clone)
    }

    return fieldNames.length;
  }

}

//viacep.com.br/ws/01001000/json/