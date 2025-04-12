import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["link", "form1", "form2"]

  connect() {
    //console.log('tabs_controller')
    this.updateLinksBasedOnURL()
  }

  showForm(event) {
    const linkId = event.target.id
    history.pushState(null, '', event.target.href);
    //console.log("showForm", event.target.href)
    this.updateLinks(linkId)
    this.formRendered(linkId)
  }

  updateLinksBasedOnURL() {
    const url = window.location.href
    //console.log("url", url)

    if (url.includes("admins_backoffice/cash_registers/cash_flows/new")) {
      this.updateLinks("link3")
      this.formRendered("link3")
    } else if (url.includes("admins_backoffice/cash_registers/cash_flows/received")) {
      this.updateLinks("link2")
      this.formRendered("link2")
    } else if (url.includes("admins_backoffice/cash_registers/cash_flows")) {
      this.updateLinks("link1")
      this.formRendered("link1")
    }
  }

  formRendered(currentLinkId) {
    //console.log("formRendered", currentLinkId)
    this.toHide()
    switch (currentLinkId) {
      case 'link1':
        this.form1Target.classList.remove('hidden')
        break;
      case 'link2':
        this.form2Target.classList.remove('hidden')
        break;

    }
  }

  toHide() {
    this.form1Target.classList.add('hidden')
    this.form2Target.classList.add('hidden')

  }

  updateLinks(currentLinkId) {
    //console.log(currentLinkId)
    this.linkTargets.forEach(link => {
      if (link.id === currentLinkId) {
        link.classList.remove('inline-block', 'p-4', 'border-b-2', 'border-transparent', 'rounded-t-lg', 'hover:text-gray-600', 'hover:border-gray-300', 'dark:hover:text-gray-300')
        link.classList.add('inline-block', 'p-4', 'text-blue-600', 'border-b-2', 'border-blue-600', 'rounded-t-lg', 'active', 'dark:text-blue-500', 'dark:border-blue-500')
      } else {
        link.classList.remove('text-blue-600', 'border-blue-600', 'active', 'dark:text-blue-500', 'dark:border-blue-500')
        link.classList.add('inline-block', 'p-4', 'border-b-2', 'border-transparent', 'rounded-t-lg', 'hover:text-gray-600', 'hover:border-gray-300', 'dark:hover:text-gray-300')
      }
    })
  }
}