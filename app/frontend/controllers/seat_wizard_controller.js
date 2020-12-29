import ApplicationController from "./application_controller"
import Api from "../lib/api"

export default class extends ApplicationController {
  static values = { addonId: String, project: Object, guestType: String, purchaseMode: String, stencils: String, workshopId: String }
  static targets = ["addonTab", "addonTabContent", "guestTab", "projectTab", "projectTabContent", "reviewTab",
    "stencilTab", "stencilTabContent"]
  static classes = ["active", "disabled"]

  initialize() {
    this.element[this.identifier] = this
    this.registerCallbacks()
    this.purchaseModeValue = undefined

    if (this.projectValue.id !== undefined) {
      this.refreshSidebar()
      this.updateProjectContent(false) // what is the actual guest type?
      this.updateAddonContent()
      this.updateStencilContent()
    }
  }

  registerCallbacks() {
    document.addEventListener('SeatWizard:reset', function (event) {
      this.purchaseModeValue = undefined
      this.guestTypeValue = undefined
      this.projectValue = {}
      this.addonIdValue = undefined
      this.stencilsValue = undefined

      this.addonTabContentTarget.innerHTML = ''
      this.stencilTabContentTarget.innerHTML = ''

      this.projectTabTarget.classList.add(this.disabledClass)
      this.addonTabTarget.classList.add(this.disabledClass)
      this.stencilTabTarget.classList.add(this.disabledClass)
      this.reviewTabTarget.classList.add(this.disabledClass)

      this.updateTabs()
    }.bind(this))

    document.addEventListener('SeatWizard:updateGuestType', function (event) {
      console.log('SeatWizard:updateGuestType')
      console.log(event.detail)

      this.purchaseModeValue = event.detail.purchaseMode
      this.guestTypeValue = event.detail.guestType

      this.refreshSidebar()

      if (event.detail.valid) {
        this.updateTabs()
      } else {
        this.projectTabTarget.classList.add(this.disabledClass)
        this.addonTabTarget.classList.add(this.disabledClass)
        this.stencilTabTarget.classList.add(this.disabledClass)
        this.reviewTabTarget.classList.add(this.disabledClass)
      }
    }.bind(this))

    document.addEventListener('SeatWizard:updateProject', function (event) {
      this.projectValue = event.detail
    }.bind(this))

    document.addEventListener('SeatWizard:updateAddon', function (event) {
      this.addonIdValue = event.detail.id
    }.bind(this))

    document.addEventListener('SeatWizard:updateStencils', function (event) {
      this.stencilsValue = event.detail
    }.bind(this))
  }

  goToTab(e) {
    e.preventDefault()

    switch (e.currentTarget.dataset.destination) {
      case 'guest':
        $(this.guestTabTarget).tab('show')
        break

      case 'project':
        $(this.projectTabTarget).tab('show')
        break

      case 'stencil':
        $(this.stencilTabTarget).tab('show')
        break

      case 'addon':
        $(this.addonTabTarget).tab('show')
        break

      case 'review':
        $(this.reviewTabTarget).tab('show')
        break

      default:
        break
    }
  }

  // private

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

    this.refreshSidebar()
    this.updateStencilContent()
    this.stencilTabTarget.classList.remove(this.disabledClass)
    this.reviewTabTarget.classList.add(this.disabledClass)
  }

  addonIdValueChanged() {
    if (this.projectValue.id === undefined || !this.hasAddonIdValue) {
      return
    }

    this.refreshSidebar()
  }

  stencilsValueChanged() {
    if (this.projectValue.id === undefined) {
      return
    }

    if (this.stencilsValue !== '') {
      this.reviewTabTarget.classList.remove(this.disabledClass)
    }

    this.refreshSidebar()
  }

  updateTabs() {
    if (this.purchaseModeValue === 'now') {
      this.updateProjectContent(this.guestTypeValue === 'child')
      this.projectTabTarget.classList.remove(this.disabledClass)
      this.addonTabTarget.classList.add(this.disabledClass)
      this.stencilTabTarget.classList.add(this.disabledClass)
      this.reviewTabTarget.classList.add(this.disabledClass)
    } else if (this.purchaseModeValue === 'later') {
      this.projectTabContentTarget.innerHTML = ''

      this.projectTabTarget.classList.add(this.disabledClass)
      this.addonTabTarget.classList.add(this.disabledClass)
      this.stencilTabTarget.classList.add(this.disabledClass)
      this.reviewTabTarget.classList.remove(this.disabledClass)
    }
  }

  updateProjectContent(includeChildProjects) {
    Api.workshopProjects(this.workshopIdValue, includeChildProjects)
      .then(resp => {
        this.projectTabContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }

  updateStencilContent() {
    Api.projectStencils(this.projectValue.id)
      .then(resp => {
        this.stencilTabContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }

  updateAddonContent() {
    Api.projectAddons(this.projectValue.id)
      .then(resp => {
        this.addonTabContentTarget.innerHTML = resp.data
      })
      .catch(err => {
        console.error(err)
        alert('An error occurred. Please try again.')
      })
  }

  refreshSidebar() {
    document.dispatchEvent(new CustomEvent('SeatWizard:refreshSidebar', {
      detail: {
        project_id: this.projectValue.id,
        addon_id: this.addonIdValue,
        stencils: this.stencilsValue,
        guestType: this.guestTypeValue,
        purchaseMode: this.purchaseModeValue
      }
    }))
  }
}
