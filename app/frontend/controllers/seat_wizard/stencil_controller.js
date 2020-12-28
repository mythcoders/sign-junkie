import ApplicationController from "../application_controller"
import { Isotope } from 'isotope-layout'

export default class extends ApplicationController {
  static values = { visible: Boolean, maxStencils: Number, stencilIds: Array, filters: String }
  static targets = ["grid", "nextButton", "previousButton", "stencil", "column", "stencilField", "personalization"]
  static classes = ["active"]

  initialize() {
    this.iso = new Isotope(this.gridTarget, {
      layoutMode: "masonry",
      itemSelector: "stencil"
    })
  }

  connect() {
    var imagesLoaded = require('imagesloaded')
    imagesLoaded(this.gridTarget).on('progress', () => {
      this.iso.layout()
    })

    this.iso.layout()
  }

  disconnect() {
    this.iso.destroy()
  }

  changeCategoryFilter(e) {
    this.filtersValue = e.currentTarget.value !== '' ? `.sc-${e.currentTarget.value}` : null
    debugger
    this.iso.arrange({
      filter: this.filtersValue
    })
  }

  toggleStencil(e) {
    e.preventDefault()

    let element = e.currentTarget
    let stencils = this.stencilIdsValue

    if (element.dataset.selected === 'true') {
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

    e.currentTarget.dataset.selected = !element.dataset.selected
    this.stencilIdsValue = stencils
    // this.stencilFieldTarget.value =

    this.updateStencilTargets()
    this.updatePersonalizationTargets()
    this.notifySeatWizard()
  }

  togglePlainOption(e) {
    this.visibleValue = e.currentTarget.checked
    this.stencilIdsValue = [0]
    this.notifySeatWizard()
    this.columnTargets.forEach((element) => {
      element.hidden = this.visibleValue
    })
  }

  updateStencilPersonalization(e) {
    // update the form field
    // FORMAT: stencil_id|customization,
    // this.stencilFieldTarget.value =
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
    this.personalizationTargets.forEach((element) => {
      if (this.stencilIdsValue.includes(element.dataset.id) && element.dataset.allowPersonalization === 'true') {
        element.hidden = false
      } else {
        element.hidden = true
      }
    })
  }
}
