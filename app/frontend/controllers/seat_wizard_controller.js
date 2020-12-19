import axios from "axios"
import ApplicationController from "./application_controller"

export default class extends ApplicationController {
  static classes = ["active", "disabled"]
  static targets = [
    "addon",
    "addonTab",
    "addonTabContent",
    "priceDisplay",
    "project",
    "projectTab",
    "projectTabContent",
    "reviewTab",
    "stencil",
    "stencilTab",
    "stencilTabContent",
  ]
  static values = {
    addon: Object,
    guest: Object,
    project: Object,
    stencils: Array,
    workshopId: String,
  }

  get sidebarInformation() {
    return {
      addon: this.addonValue,
      project: this.projectValue,
      stencils: this.stencilsValue,
    }
  }

  connect() {
    this.element[this.identifier] = this

    if (this.projectValue.id !== undefined) {
      this.updateAddonContent()
      this.updateStencilContent()
    }
  }

  toggleGuestType(e) {
    e.preventDefault()

    this.guestValue.type = e.currentTarget.value

    this.updateProjectContent(this.guestValue.type === 'child')
    this.projectTabTarget.classList.remove(this.disabledClass)
    this.addonTabTarget.classList.add(this.disabledClass)
    this.stencilTabTarget.classList.add(this.disabledClass)
    this.reviewTabTarget.classList.add(this.disabledClass)
  }

  pickProject(e) {
    e.preventDefault()

    this.projectValue = {
      id: e.currentTarget.dataset.id,
      name: e.currentTarget.dataset.name,
      price: parseFloat(e.currentTarget.dataset.price),
      imageUrl: e.currentTarget.dataset.imageUrl
    }

    this.updateStencilContent()
    this.updateAddonContent()
    this.addonTabTarget.classList.remove(this.disabledClass)
    this.stencilTabTarget.classList.remove(this.disabledClass)
    this.reviewTabTarget.classList.add(this.disabledClass)
  }

  pickStencil(e) {
    e.preventDefault()

    let selectedElement = e.currentTarget
    // set the form value

    this.reviewTabTarget.classList.remove(this.disabledClass)
  }

  pickAddon(e) {
    e.preventDefault()

    this.addonValue = {
      id: e.currentTarget.dataset.id,
      name: e.currentTarget.dataset.name,
      price: parseFloat(e.currentTarget.dataset.price)
    }
  }

  submit() {

  }

  // private

  updateProjectContent(includeChildProjects) {
    let url = `/workshops/${this.workshopIdValue}/projects`
    axios.get(includeChildProjects ? `${url}?include_children=1` : url)
      .then(resp => {
        this.projectTabContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }

  updateStencilContent() {
    axios.get(`/projects/${this.projectValue.id}/stencils`)
      .then(resp => {
        this.stencilTabContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }

  updateAddonContent() {
    axios.get(`/projects/${this.projectValue.id}/addons`)
      .then(resp => {
        this.addonTabContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }
}