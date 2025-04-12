import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
  static targets = ["search", "results", "table", "clientId"]
  static debounces = ["searchClients"]

  connect() {
    //console.log('searchClients_controller')
    useDebounce(this, { wait: 500 })
  }

  searchClients() {
    const searchValue = this.searchTarget.value;
    const url = `/admins_backoffice/cash_registers/cash_flows/search?search=${encodeURIComponent(searchValue)}`

    // Se searchValue for vazio, retorne imediatamente
    if (!searchValue.trim()) {
      this.resultsTarget.innerHTML = ""
      return;
    }

    fetch(url, {
      method: 'GET',
    })
      .then(response => response.json())
      .then(data => {
        if (data.length == 0) {
          this.resultsTarget.innerHTML = '<p class="block w-full  text-center text-blue-500 dark:text-gray-400">Nenhum cliente encontrado</p>';
          return;
        }
        this.resultsTarget.innerHTML = '';
        data.forEach(client => {
          const element = document.createElement('a');
          element.href = '#';
          element.className = 'block w-full px-4 py-2 border-b border-gray-200 cursor-pointer hover:bg-gray-100 hover:text-blue-700 focus:outline-none focus:ring-2 focus:ring-blue-700 focus:text-blue-700 dark:border-gray-600 dark:hover:bg-gray-600 dark:hover:text-white dark:focus:ring-gray-500 dark:focus:text-white';

          element.addEventListener('click', this.handleClientClick.bind(this));
          element.textContent = client.name_client;
          // Armazena o ID do cliente no elemento
          element.dataset.clientName = client.name_client;
          this.resultsTarget.appendChild(element);
        });
      })

      .catch((error) => {
        console.error('Error:', error)
      });
  }

  handleClientClick(event) {
    event.preventDefault()
    const clientName = event.currentTarget.dataset.clientName
    this.searchTarget.value = clientName
    this.resultsTarget.innerHTML = ""
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
  }

}