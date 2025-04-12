import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ["inputLauchDate", "inputReleaseDescription", "inputLauchValue", "template", "table", "message", "total", "totalReceived", "fields", "myElement"]
  static outlets = ["services--results"]
  static debounces = ["calculateTotal"]

  connect() {
    //console.log('additionalCharge_controller')
    useDebounce(this, { wait: 500 })
    this.toCheck()
    this.calculateTotal()
  }

  formatValue(event) {
    event.preventDefault()
    let value = this.inputLauchValueTarget.value

    value = value.replace(/\D/g, '')

    let formattedValue = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value / 100);
    this.inputLauchValueTarget.value = formattedValue
  }

  addReceived(event) {
    event.preventDefault()

    if (this.validateFields() > 0) {
      return;
    }

    let lauchDate = this.inputLauchDateTarget.value ? this.inputLauchDateTarget.value : new Date().toLocaleDateString('pt-BR')
    let releaseDescription = this.inputReleaseDescriptionTarget.value
    let lauchValue = this.inputLauchValueTarget.value

    let row = this.templateTarget.content.cloneNode(true)

    row.querySelector('.lauch_date').textContent = lauchDate
    row.querySelector('.release_description').textContent = releaseDescription
    row.querySelector('.lauch_value').textContent = lauchValue

    row.querySelector('.lauch_date-input').value = lauchDate
    row.querySelector('.release_description-input').value = releaseDescription
    row.querySelector('.lauch_value-input').value = lauchValue

    this.tableTarget.appendChild(row)

    this.inputLauchDateTarget.value = ''
    this.inputReleaseDescriptionTarget.value = ''
    this.inputLauchValueTarget.value = ''

    this.toCheck()
    this.calculateTotal()
  }

  deleteReceived(event) {
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
    this.calculateTotal()
  }

  editReceived(event) {
    event.preventDefault();

    let row = event.target.closest('tr');

    let lauchDate = row.querySelector('.lauch_date');
    let releaseDescription = row.querySelector('.release_description');
    let lauchValue = row.querySelector('.lauch_value');

    this.deleteReceived(event);

    this.inputLauchDateTarget.value = lauchDate.textContent
    this.inputReleaseDescriptionTarget.value = releaseDescription.textContent
    this.inputLauchValueTarget.value = lauchValue.textContent
    this.calculateTotal()
  }

  toCheck() {
    let rows = this.tableTarget.querySelectorAll('tr');
    let visibleRows = Array.from(rows).filter(row => window.getComputedStyle(row).display !== 'none');

    if (visibleRows.length <= 1) {
      // O campo está vazio
      this.tableTarget.classList.add('hidden');
      this.messageTarget.classList.remove('hidden');
      this.totalTarget.classList.add('hidden');
    } else {
      this.tableTarget.classList.remove('hidden');
      this.messageTarget.classList.add('hidden');
      this.totalTarget.classList.remove('hidden');
    }
  }

  calculateTotal() {

    let total = 0
    this.tableTarget.querySelectorAll('.lauch_value').forEach((cell) => {
      // Verifica se o elemento pai (linha) da célula contém a classe 'hidden'
      if (cell.parentNode.classList.contains('hidden')) {
        return; // Continua para a próxima iteração do loop se a linha estiver oculta
      }

      let value = cell.textContent
      value = value.replace(/\D/g, '')  // Remove caracteres não numéricos
      value = value === "" ? 0 : parseFloat(value) / 100; // Dividir por 100 para considerar centavos

      if (!isNaN(value)) {
        total += value
      }
    })
    // Formata o total como uma string de moeda
    let formattedTotal = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(total);
    this.totalTarget.textContent = `Total: ${formattedTotal}`
    this.totalReceivedTarget.textContent = formattedTotal
    this.servicesResultsOutlet.calcReceived()
  }

  validateFields() {
    let fields = [this.inputLauchDateTarget, this.inputReleaseDescriptionTarget, this.inputLauchValueTarget]
    let fieldNames = []

    for (let field of fields) {
      if (!field.value) {
        switch (field) {
          case this.inputLauchDateTarget:
            fieldNames.push('Data campo obrigatório')
            break
          case this.inputReleaseDescriptionTarget:
            fieldNames.push('Descrição campo obrigatório')
            break
          case this.inputLauchValueTarget:
            fieldNames.push('Valor campo obrigatório')
            break
        }

      }
    }

    let listHTML = '';
    for (let fieldName of fieldNames) {
      listHTML += `<li>${fieldName}</li>`;
    }

    let template = this.fieldsTarget;
    let clone = document.importNode(template.content, true);
    let alertElement = clone.querySelector('ul');
    alertElement.innerHTML = listHTML;

    // Insira o clone no DOM em um local apropriado
    let parentElement = this.myElementTarget;

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