import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["page1", "page2", "link"]

  connect() {
    //console.log('nav_controller')
    this.page1Target.classList.remove('hidden')
    this.updateLinks("link1")
  }

  showPage(event) {
    event.preventDefault()
    this.toHide()
    switch (event.target.id) {

      case 'link1':
        this.page1Target.classList.remove('hidden')
        break;
      case 'link2':
        this.page2Target.classList.remove('hidden')
        break;

    }
    this.updateLinks(event.target.id)
  }

  toHide() {
    this.page1Target.classList.add('hidden')
    this.page2Target.classList.add('hidden')
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