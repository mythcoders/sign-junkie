import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static classes = ["active"]
  static targets = [
    "stencil",
    "stencilPersonalization"
  ]
  static values = {
    visible: Boolean,
    maxStencils: Number,
    stencilIds: Array,
  }

  toggle(e) {
    let element = e.currentTarget

    if (this.stencilIdsValue.length === this.maxStencilsValue && !element.dataset.selected) {
      console.error('stencil limit reached!')
      e.stopImmediatePropagation()
      return
    }

    element.dataset.selected = !element.dataset.selected
    if (element.dataset.selected) {
      this.stencilIdsValue.push(element.dataset.id)
    } else {
      let pos = this.stencilIdsValue.indexOf(element.dataset.id)
      this.stencilIdsValue.splice(pos, 1)
    }

    // update the UI
    this.updateStencilTargets()
    this.updatePersonalizationTargets()
  }

  toggleStencilContent(e) {
    this.visibleValue = !e.currentTarget.checked
    this.stencilTargets.forEach((element) => {
      element.hidden = this.visibleValue
    })
  }

  // private

  updateStencilTargets() {
    this.stencilTargets.forEach((element) => {
      if (element.dataset.id === this.projectIdValue) {
        element.classList.add(this.activeClass)
      } else {
        element.classList.remove(this.activeClass)
      }
    })
  }

  updatePersonalizationTargets() {
    this.stencilPersonalizationTargets.forEach((element) => {
      if (element.dataset.id === this.projectIdValue) {
        element.hidden = !element.dataset.allowPersonalization
      } else {
        element.hidden = true
      }
    })
  }
}