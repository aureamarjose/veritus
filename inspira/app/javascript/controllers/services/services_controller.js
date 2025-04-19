import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ["inputServiceDate", "inputListServiceId", "inputAmount", "inputValue", "inputTotal", "template", "table", "serviceNamesMap", "message", "total", 'serviceTotal', "hidden", "fields", "myElement"]
  static debounces = ["calcService", "calculateTotal"]
  static outlets = ["services--results"]

  connect() {
    //console.log('services_controller')
    useDebounce(this, { wait: 500 })
    this.serviceNames = JSON.parse(this.serviceNamesMapTarget.textContent)

    // Primeiro, converte o texto para um objeto JavaScript
    const namesToIdsMap = JSON.parse(this.serviceNamesMapTarget.textContent);

    // Inverte as chaves e valores
    this.idsFromNames = Object.entries(namesToIdsMap).reduce((acc, [key, value]) => {
      acc[value] = key;
      return acc;
    }, {});

    this.toCheck()
    this.calculateTotal()

    this.services = [];
  }

  formatValue(event) {
    event.preventDefault()
    let value = this.inputValueTarget.value
    value = value.replace(/\D/g, '')

    let formattedValue = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(value / 100);
    this.inputValueTarget.value = formattedValue

    this.calcService(event)
  }

  calcService(event) {
    event.preventDefault()
    let amount = this.inputAmountTarget.value
    let value = this.inputValueTarget.value

    amount = amount === "" ? 0 : parseInt(amount);
    value = value.replace(/\D/g, ''); // Remove caracteres não numéricos
    value = value === "" ? 0 : parseFloat(value) / 100; // Dividir por 100 para considerar centavos

    let total = amount * value

    // Formata o total como uma string de moeda
    let formattedTotal = new Intl.NumberFormat('pt-BR', { style: 'currency', currency: 'BRL' }).format(total);
    this.inputTotalTarget.value = formattedTotal
  }

  addService(event) {
    event.preventDefault()

    if (this.validateFields() > 0) {
      return;
    }

    let serviceDate = this.inputServiceDateTarget.value ? this.inputServiceDateTarget.value : new Date().toLocaleDateString('pt-BR')
    let listServiceId = this.inputListServiceIdTarget.value
    let serviceName = this.serviceNames[listServiceId]
    let amount = this.inputAmountTarget.value
    let value = this.inputValueTarget.value
    let total = this.inputTotalTarget.value

    let row = this.templateTarget.content.cloneNode(true)

    row.querySelector('.service_date').textContent = serviceDate
    row.querySelector('.list_service_id').textContent = serviceName
    row.querySelector('.amount').textContent = amount
    row.querySelector('.value').textContent = value
    row.querySelector('.total').textContent = total

    row.querySelector('.service_date-input').value = serviceDate
    row.querySelector('.list_service_id-input').value = listServiceId
    row.querySelector('.amount-input').value = amount
    row.querySelector('.value-input').value = value
    row.querySelector('.total-input').value = total

    this.tableTarget.appendChild(row)
    this.inputServiceDateTarget.value = ''
    this.inputListServiceIdTarget.value = ''
    this.inputAmountTarget.value = ''
    this.inputValueTarget.value = ''
    this.inputTotalTarget.value = ''

    this.toCheck()
    this.calculateTotal()

    // Adiciona o serviço ao array
    this.services.push({
      serviceDate: serviceDate,
      listServiceId: listServiceId,
      serviceName: serviceName,
      amount: amount,
      value: value,
      total: total
    })

    this.updateOperationalCostSelect()
  }

  updateOperationalCostSelect() {
    // Seleciona o formulário de custos operacionais usando um seletor de atributo data
    const operationalCostForm = document.querySelector('[data-services--nav-target="form5"]');

    // Seleciona o elemento <select> dentro do formulário de custos operacionais
    const serviceSelect = operationalCostForm.querySelector('select[name="list_service_id"]');

    // Armazena as opções existentes
    const existingOptions = Array.from(serviceSelect.options).map(option => ({
      value: option.value,
      text: option.text
    }))

    // Limpa as opções existentes no <select>
    serviceSelect.innerHTML = ''

    // Adiciona as opções existentes de volta ao select
    existingOptions.forEach(option => {
      const newOption = document.createElement("option")
      newOption.value = option.value
      newOption.text = option.text
      serviceSelect.appendChild(newOption)
    })

    // Itera sobre o array this.services e adiciona cada serviço como uma nova opção no <select>
    this.services.forEach(service => {
      // Verifica se a opção já existe
      if (!existingOptions.some(option => option.value === service.listServiceId.toString())) {
        const option = document.createElement("option")
        option.value = service.listServiceId // Define o valor da opção como o ID do serviço
        option.text = service.serviceName // Define o texto da opção como o nome do serviço
        serviceSelect.appendChild(option) // Adiciona a nova opção ao <select>
      }
    });
  }

  deleteService(event) {
    event.preventDefault();

    let row = event.target.closest('tr');
    let destroyInput = row.querySelector('.destroy-input');
    console.log("destroyInput", destroyInput)

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

  editServices(event) {

    event.preventDefault();

    let row = event.target.closest('tr');

    let serviceDate = row.querySelector('.service_date');
    let serviceName = row.querySelector('.list_service_id');
    let listServiceId = this.idsFromNames[serviceName.textContent]
    let amount = row.querySelector('.amount');
    let value = row.querySelector('.value');
    let total = row.querySelector('.total');

    this.deleteService(event);

    this.inputServiceDateTarget.value = serviceDate.textContent
    this.inputListServiceIdTarget.value = listServiceId
    this.inputAmountTarget.value = amount.textContent
    this.inputValueTarget.value = value.textContent
    this.inputTotalTarget.value = total.textContent

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
    this.tableTarget.querySelectorAll('.total').forEach((cell) => {

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
    this.serviceTotalTarget.textContent = formattedTotal
    this.servicesResultsOutlet.calcReceived()
  }

  validateFields() {
    let fields = [this.inputServiceDateTarget, this.inputListServiceIdTarget, this.inputAmountTarget, this.inputValueTarget, this.inputTotalTarget]
    let fieldNames = []

    for (let field of fields) {
      if (!field.value) {
        switch (field) {
          case this.inputServiceDateTarget:
            fieldNames.push(window.translations.messageServiceDate)
            break
          case this.inputListServiceIdTarget:
            fieldNames.push(window.translations.messageServiceService)
            break
          case this.inputAmountTarget:
            fieldNames.push(window.translations.messageServiceQuantity)
            break
          case this.inputValueTarget:
            fieldNames.push(window.translations.messageServiceAmount)
            break
          case this.inputTotalTarget:
            fieldNames.push(window.translations.messageServiceTotal)
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