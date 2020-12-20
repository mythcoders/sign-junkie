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
    "sidebarContent",
    "stencil",
    "stencilTab",
    "stencilTabContent",
  ]
  static values = {
    addonId: String,
    project: Object,
    guest: Object,
    stencils: Array,
    workshopId: String,
  }

  connect() {
    this.element[this.identifier] = this
    this.registerCallbacks()

    if (this.projectValue.id !== undefined) {
      this.updateSidebarContent()
      this.updateProjectContent()
      this.updateAddonContent()
      this.updateStencilContent()
    }
  }

  registerCallbacks() {
    document.addEventListener('seatWizard.navigation', function (event) {
      debugger
    }.bind(this))

    document.addEventListener('seatWizard.reset', function (event) {
      this.guestValue = {}
      this.projectValue = {}
      this.stencilsValue = []
      this.addonIdValue = undefined

      this.projectTabTarget.classList.add(this.disabledClass)
      this.addonTabTarget.classList.add(this.disabledClass)
      this.stencilTabTarget.classList.add(this.disabledClass)
      this.reviewTabTarget.classList.add(this.disabledClass)
    }.bind(this))

    document.addEventListener('seatWizard.toggleGuestType', function (event) {
      this.guestValue = event.detail
    }.bind(this))

    document.addEventListener('seatWizard.updateProject', function (event) {
      this.projectValue = event.detail
    }.bind(this))

    document.addEventListener('seatWizard.updateAddon', function (event) {
      this.addonIdValue = event.detail.id
    }.bind(this))

    document.addEventListener('seatWizard.updateStencils', function (event) {
      this.stencilsValue = event.detail
    }.bind(this))
  }

  submit() {

  }

  // private

  guestValueChanged() {
    if (this.guestValue.guestType === undefined) {
      return
    }

    this.updateProjectContent(this.guestValue.guestType === 'child')
    this.projectTabTarget.classList.remove(this.disabledClass)
    this.addonTabTarget.classList.add(this.disabledClass)
    this.stencilTabTarget.classList.add(this.disabledClass)
    this.reviewTabTarget.classList.add(this.disabledClass)
  }

  projectValueChanged() {
    if (this.projectValue.id === undefined) {
      return
    }

    if (this.projectValue.addons) {
      this.updateAddonContent()
      this.addonTabTarget.classList.remove(this.disabledClass)
    } else {
      this.addonTabTarget.classList.add(this.disabledClass)
    }

    this.updateSidebarContent()
    this.updateStencilContent()
    this.stencilTabTarget.classList.remove(this.disabledClass)
    this.reviewTabTarget.classList.add(this.disabledClass)
  }

  addonIdValueChanged() {
    if (!this.hasAddonIdValue) {
      return
    }

    this.updateSidebarContent()
  }

  stencilsValueChanged() {
    if (this.stencilsValue.length === 0) {
      return
    }

    this.reviewTabTarget.classList.remove(this.disabledClass)

    this.updateSidebarContent()
  }

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

  updateSidebarContent() {
    //TODO: POST the params for cart!!!
    var url = new URL(window.location.origin + `/projects/${this.projectValue.id}/sidebar`)

    if (this.hasAddonIdValue) {
      url.searchParams.append('addon_id', this.addonIdValue)
    }

    for (let i = 0; i < this.stencilsValue.length; i++) {
      url.searchParams.append('stencil_ids[]', this.stencilsValue[i])
    }

    console.log(url.href)
    axios.get(url.href)
      .then(resp => {
        this.sidebarContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }
}
