
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "link"]
  deleteEvent = null;
  url = null;
  csrf = null;
  origin = null;

  connect() {
    //console.log('confirm controller connected')
  }

  delete(event) {
    event.preventDefault();
    this.deleteEvent = event;
    this.modalTarget.classList.remove('hidden');
    this.url = event.currentTarget.dataset.url
    this.csrf = event.currentTarget.dataset.csrf
    this.origin = event.currentTarget.dataset.origin
    //console.log('delete', this.origin)
  }

  confirmDelete() {
    const url = this.url
    const csrf = this.csrf
    fetch(url, {
      method: 'DELETE',
      headers: {
        'X-CSRF-Token': csrf,
        'Content-Type': 'text/html',
        'Accept': 'text/vnd.turbo-stream.html'
      },
      credentials: 'same-origin'
    }).then(response => {
      if (response.ok) {
        //console.log('response ok')
        return response.text();
      } else {
        throw new Error('Erro ao excluir!!!!');
      }
    }).then(data => {
      if (data.startsWith('<turbo-stream')) {
        if (this.origin == "client") {
          Turbo.renderStreamMessage(data);
          Toastify({
            text: "Cliente apagado com sucesso",
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        } else if (this.origin == "service") {
          Turbo.renderStreamMessage(data);
          Toastify({
            text: "Serviço apagado com sucesso",
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        } else if (this.origin == "list_service") {
          Turbo.renderStreamMessage(data);
          Toastify({
            text: "Serviço apagado com sucesso",
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        } else if (this.origin == "categories_accounts_payable") {
          Turbo.renderStreamMessage(data);
          Toastify({
            text: "Categoria apagada com sucesso",
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        } else if (this.origin == "bills_to_pay") {
          Turbo.renderStreamMessage(data);
          Toastify({
            text: "Conta apagada com sucesso",
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        }
        else if (this.origin == "cash_flow") {
          Turbo.renderStreamMessage(data);
          Toastify({
            text: "Saldo excluído com sucesso.",
            duration: 3000,
            style: {
              background: "#22c55e",
            }
          }).showToast();
        }
      } else {
        throw new Error('Resposta inválida do servidor!');
      }
    }).catch(error => {
      if (this.origin == "categories_accounts_payable") {
        Toastify({
          text: "Categoria não pode ser apagada, pois existem contas a pagar associadas.",
          duration: 3000,
          style: {
            background: "red",
          }
        }).showToast();
      } else if (this.origin == "list_service") {
        Toastify({
          text: "Serviço não pode ser apagado.",
          duration: 3000,
          style: {
            background: "red",
          }
        }).showToast();
      } else {
        Toastify({
          text: error,
          duration: 3000,
          style: {
            background: "red",
          }
        }).showToast();
      }
    });
  }

  cancelDelete(event) {
    //console.log('cancel delete')
    event.preventDefault();
    this.modalTarget.classList.add('hidden');
  }

  displayModal() {
    this.modalTarget.classList.add('hidden');
  }



}