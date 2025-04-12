import { Controller } from "@hotwired/stimulus"
import { useDebounce } from 'stimulus-use'

export default class extends Controller {
    static targets = ["search", "results", "table", "clientId", "message"]
    static debounces = ["searchClients"]

    connect() {
        //console.log('searchClients_controller')
        this.toCheck()
        useDebounce(this, { wait: 500 })
    }

    searchClients() {
        const searchValue = this.searchTarget.value;
        const url = `/admins_backoffice/clients/search?search=${encodeURIComponent(searchValue)}`;

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
                    element.dataset.clientId = client.id;
                    this.resultsTarget.appendChild(element);
                });
            })

            .catch((error) => {
                console.error('Error:', error);
            });
    }

    handleClientClick(event) {
        event.preventDefault();

        const clientId = event.target.dataset.clientId;
        this.clientIdTarget.value = clientId;
        // console.log('client_Id', this.client_IdTarget.value);
        // console.log('handleClientClick', clientId);

        const url = `/admins_backoffice/clients/${clientId}/show_client`;
        //console.log('url', url);

        fetch(url, {
            method: 'GET',
        })
            .then(response => response.json())
            .then(data => {
                //console.log('Data renderizar:', data);
                // Fetch phones and emails data
                const phonesUrl = `/admins_backoffice/clients/${clientId}/phones`;
                const emailsUrl = `/admins_backoffice/clients/${clientId}/emails`;

                Promise.all([
                    fetch(phonesUrl).then(response => response.json()),
                    fetch(emailsUrl).then(response => response.json())
                ])
                    .then(([phonesData, emailsData]) => {
                        // Add phones and emails data to the client data                       
                        data.phones = phonesData;
                        data.emails = emailsData;

                        this.renderClientData(data);
                        this.resultsTarget.innerHTML = ""
                        this.searchTarget.value = ""
                    })
                    .catch((error) => {
                        console.error('Error:', error);
                    });
            })
            .catch((error) => {
                console.error('Error:', error);
            });
    }

    renderClientData(client) {
        const table = document.querySelector('.data-table');
        const tbody = table.querySelector('tbody');

        // Limpa o corpo da tabela
        tbody.innerHTML = '';

        // Cria uma nova linha para o cliente
        const tr = document.createElement('tr');
        tr.id = `client_${client.id}`;
        tr.className = 'bg-white border-b dark:bg-gray-800 dark:border-gray-700 hover:bg-gray-50 dark:hover:bg-gray-600';

        // Cria um novo elemento de botão
        const deleteButton = document.createElement('button');
        deleteButton.innerHTML = `<svg class="w-6 h-6 text-gray-800 dark:text-white" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" width="24" height="24" fill="currentColor" viewBox="0 0 24 24">
        <path fill-rule="evenodd" d="M8.586 2.586A2 2 0 0 1 10 2h4a2 2 0 0 1 2 2v2h3a1 1 0 1 1 0 2v12a2 2 0 0 1-2 2H7a2 2 0 0 1-2-2V8a1 1 0 0 1 0-2h3V4a2 2 0 0 1 .586-1.414ZM10 6h4V4h-4v2Zm1 4a1 1 0 1 0-2 0v8a1 1 0 1 0 2 0v-8Zm4 0a1 1 0 1 0-2 0v8a1 1 0 1 0 2 0v-8Z" clip-rule="evenodd"/></svg>`;

        // Adiciona um event listener ao botão
        deleteButton.addEventListener('click', (event) => {
            event.preventDefault();
            this.deleteClient(client.id);
        });

        // Cria a última célula e adiciona o botão a ela
        const deleteCell = document.createElement('td');
        deleteCell.className = 'px-6 py-4';
        deleteCell.appendChild(deleteButton);

        // Adiciona as células à linha
        tr.innerHTML = `
        <td class="px-6 py-4">${client.name_client}</td>
        <td class="px-6 py-4">${client.number_doc}</td>
        <td class="px-6 py-4">${client.phones.map(phone => `${phone.phone}<br>`).join('')}</td>
        <td class="px-6 py-4">${client.emails.map(email => `${email.email}<br>`).join('')}</td>
    `;
        tr.appendChild(deleteCell);

        // Adiciona a linha ao corpo da tabela
        tbody.appendChild(tr);
        this.toCheck()
    }

    deleteClient(clientId) {
        // Encontre a linha correspondente na tabela
        const tr = document.getElementById(`client_${clientId}`);
        // Se a linha existir, remova-a
        if (tr) {
            tr.parentNode.removeChild(tr);
            this.clientIdTarget.value = ""
            this.toCheck()
        }
    }

    deleteClient2(event) {
        // Previne o comportamento padrão do botão
        event.preventDefault();

        // Obtém o botão que foi clicado
        const button = event.currentTarget;

        // Obtém o ID do cliente do atributo de dados do botão
        const clientId = button.dataset.clientId;

        // Encontra a linha correspondente na tabela
        const tr = document.getElementById(`client_${clientId}`);

        // Se a linha existir, remova-a
        if (tr) {
            tr.parentNode.removeChild(tr);
            this.clientIdTarget.value = ""
            this.toCheck()
        }
    }

    toCheck() {
        //let rows = this.tableTarget.querySelectorAll('tr');
        let rows = Array.from(this.tableTarget.querySelectorAll('tr')).slice(1)

        if (rows.length <= 1) {
            this.tableTarget.classList.add('hidden');
            this.messageTarget.classList.remove('hidden');
            this.searchTarget.disabled = false;
        }

        rows.forEach((row) => {
            // Supondo que a célula name_client seja a segunda célula em cada linha
            let nameClientCell = row.cells[1];

            if (nameClientCell) {
                let text = nameClientCell.textContent || nameClientCell.innerText;

                if (!text.trim()) {
                    //console.log('A célula name_client está em branco na linha', row);
                    this.tableTarget.classList.add('hidden');
                    this.messageTarget.classList.remove('hidden');
                    this.searchTarget.disabled = false;
                } else {
                    //console.log('A célula name_client não está em branco na linha', row);
                    this.tableTarget.classList.remove('hidden');
                    this.messageTarget.classList.add('hidden');
                    this.searchTarget.disabled = true;
                }
            }
        });


    }
}