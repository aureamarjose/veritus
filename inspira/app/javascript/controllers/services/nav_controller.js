import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form1", "form2", "form3", "form4", "form5", "form6", "form7", "link"]

  connect() {
    //console.log('nav_controller')
    this.form1Target.classList.remove('hidden')
    this.updateLinks("link1")
  }

  showForm(event) {
    event.preventDefault()
    this.toHide()
    switch (event.target.id) {

      case 'link1':
        this.form1Target.classList.remove('hidden')
        break;
      case 'link2':
        this.form2Target.classList.remove('hidden')
        break;
      case 'link3':
        this.form3Target.classList.remove('hidden')
        break;
      case 'link4':
        this.form4Target.classList.remove('hidden')
        break;
      case 'link5':
        this.form5Target.classList.remove('hidden')
        break;
      case 'link6':
        this.form6Target.classList.remove('hidden')
        break;
      case 'link7':
        this.form7Target.classList.remove('hidden')
        break;

    }
    this.updateLinks(event.target.id)
  }

  toHide() {
    this.form1Target.classList.add('hidden')
    this.form2Target.classList.add('hidden')
    this.form3Target.classList.add('hidden')
    this.form4Target.classList.add('hidden')
    this.form5Target.classList.add('hidden')
    this.form6Target.classList.add('hidden')
    this.form7Target.classList.add('hidden')
  }

  updateLinks(currentLinkId) {
    this.linkTargets.forEach(link => {
      if (link.id === currentLinkId) {
        link.classList.remove('inline-block', 'p-4', 'border-b-2', 'border-transparent', 'rounded-t-lg', 'hover:text-gray-600', 'hover:border-gray-300', 'dark:hover:text-gray-300')
        link.classList.add('inline-block', 'p-4', 'text-blue-600', 'border-b-2', 'border-blue-600', 'rounded-t-lg', 'active', 'dark:text-blue-500', 'dark:border-blue-500');
      } else {
        link.classList.remove('text-blue-600', 'border-blue-600', 'active', 'dark:text-blue-500', 'dark:border-blue-500')
        link.classList.add('inline-block', 'p-4', 'border-b-2', 'border-transparent', 'rounded-t-lg', 'hover:text-gray-600', 'hover:border-gray-300', 'dark:hover:text-gray-300')
      }
    })
  }

}