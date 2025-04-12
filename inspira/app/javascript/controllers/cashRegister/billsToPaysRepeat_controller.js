import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["inputDescription", "inputCategory", "inputValue", "inputFrequency", "inputStartDate", "inputRepetitions", "fields", "myElement"]

  connect() {
    //console.log('billToPaysRepeat_controller')
  }

  createRecurringBills() {
    const description = this.inputDescriptionTarget.value
    const category = this.inputCategoryTarget.value
    const value = this.inputValueTarget.value
    const frequency = this.inputFrequencyTarget.value
    const startDate = this.inputStartDateTarget.value
    const repetitions = this.inputRepetitionsTarget.value

    // Dividindo a string da data para obter dia, mês e ano
    let [day, month, year] = startDate.split('/').map(Number);

    // Criando um objeto Date usando a data local
    let currentDate = new Date(year, month - 1, day); // Mês é zero-indexado

    const bills = []

    for (let i = 0; i < repetitions; i++) {
      console.log('iteration', i + 1);
      bills.push({
        expiration_date: currentDate.toISOString().split('T')[0],
        description: description,
        category_id: category,
        value: value,
        status: false,
      });
      currentDate = this.getNextDate(currentDate, frequency);
    }

    this.sendBillsToServer(bills);
  }

  getNextDate(date, frequency) {
    const nextDate = new Date(date);
    switch (frequency) {
      case 'weekly':
        nextDate.setDate(nextDate.getDate() + 7);
        break;
      case 'monthly':
        nextDate.setMonth(nextDate.getMonth() + 1);
        break;
      case 'yearly':
        nextDate.setFullYear(nextDate.getFullYear() + 1);
        break;
      default:
        throw new Error('Frequência desconhecida: ' + frequency);
    }
    return nextDate;
  }

  async sendBillsToServer(bills) {
    if (this.validateFields() > 0) {
      return;
    }
    try {
      const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
      const response = await fetch('/admins_backoffice/cash_registers/bills_to_pays', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': csrfToken,
          'Accept': 'application/json'
        },
        body: JSON.stringify({ bills_to_pay: bills }),
      });

      if (!response.ok) {
        const errorText = await response.text();
        console.error('Erro na resposta do servidor:', errorText);
        throw new Error('Erro ao salvar os lançamentos');
      }

      const data = await response.json();

      if (data.redirect_url) {
        if (data.notice) {
          Toastify({
            text: data.notice,
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        }

        setTimeout(() => {
          window.location.href = data.redirect_url;
        }, 1500);

      }
      this.clearInput()


    } catch (error) {
      console.error('Erro:', error);
      Toastify({
        text: "Erro ao salvar os lançamentos",
        duration: 3000,
        style: {
          background: "red",
        }
      }).showToast();
    }
  }

  validateFields() {
    let fields = [this.inputDescriptionTarget, this.inputCategoryTarget, this.inputValueTarget, this.inputFrequencyTarget, this.inputStartDateTarget, this.inputRepetitionsTarget]
    let fieldNames = []

    for (let field of fields) {
      if (!field.value) {
        switch (field) {
          case this.inputDescriptionTarget:
            fieldNames.push('Descrição campo obrigatório')
            break
          case this.inputCategoryTarget:
            fieldNames.push('Categoria campo obrigatório')
            break
          case this.inputValueTarget:
            fieldNames.push('Valor campo obrigatório')
            break
          case this.inputFrequencyTarget:
            fieldNames.push('Tipo de repetição campo obrigatório')
            break
          case this.inputStartDateTarget:
            fieldNames.push('Data de início campo obrigatório')
            break
          case this.inputRepetitionsTarget:
            fieldNames.push('Quantidade de repetições campo obrigatório')
            break
        }

      }
    }
    //console.log('fieldNames', fieldNames);
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

  clearInput() {
    this.inputDescriptionTarget.value = ''
    this.inputValueTarget.value = ''
    this.inputFrequencyTarget.value = ''
    this.inputStartDateTarget.value = ''
    this.inputRepetitionsTarget.value = ''
  }

}