import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static classes = ["active"]
  static targets = [
    "stencil",
    "stencilColumn",
    "stencilPersonalization"
  ]
  static values = {
    visible: Boolean,
    maxStencils: Number,
    stencilIds: Array,
  }

  toggle(e) {
    e.preventDefault()

    let element = e.currentTarget
    let stencils = this.stencilIdsValue

    if (element.dataset.selected) {
      let pos = stencils.indexOf(element.dataset.id)
      stencils.splice(pos, 1)
    } else {
      if (this.stencilIdsValue.length === this.maxStencilsValue) {
        if (this.maxStencilsValue === 1) {
          // in this scenario we want the selector to function as a toggle
          // and and we go ahead and 'unselect' the other stencil
          stencils = []
        } else {
          alert("You've reached your limit on stencils. Please unselect an existing stencil before trying to select another one.")
          e.stopImmediatePropagation()
          return
        }
      }

      stencils.push(element.dataset.id)
    }

    element.dataset.selected = !element.dataset.selected
    this.stencilIdsValue = stencils

    this.updateStencilTargets()
    this.updatePersonalizationTargets()
    this.notifySeatWizard()
  }

  toggleStencilContent(e) {
    this.visibleValue = e.currentTarget.checked
    this.stencilColumnTargets.forEach((element) => {
      element.hidden = this.visibleValue
    })
  }

  // private

  notifySeatWizard() {
    document.dispatchEvent(new CustomEvent('seatWizard.updateStencils', {
      detail: this.stencilIdsValue
    }))
  }

  updateStencilTargets() {
    this.stencilTargets.forEach((element) => {
      if (this.stencilIdsValue.includes(element.dataset.id)) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })
  }

  updatePersonalizationTargets() {
    this.stencilPersonalizationTargets.forEach((element) => {
      if (this.stencilIdsValue.includes(element.dataset.id) && element.dataset.allowPersonalization === 'true') {
        element.hidden = false
      } else {
        element.hidden = true
      }
    })
  }
}
