import { Controller } from "@hotwired/stimulus"


export default class extends Controller {
  static targets = ["inputFolder", "inputFinancialSituation"]

  connect() {

  }

  format() {
    console.log('format');
    // Remove todos os caracteres que não são dígitos
    let value = this.inputFolderTarget.value.replace(/\D/g, '');

    // Remove zeros iniciais, exceto se o número for apenas '0'
    value = value.replace(/^0+/, '') || '0';

    // Converte para número e formata com separadores de milhar
    let formattedValue = Number(value).toLocaleString('pt-BR');

    this.inputFolderTarget.value = formattedValue === '0' ? '' : formattedValue;

  }

}