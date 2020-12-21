import ApplicationController from "../application_controller"
import isotope from 'isotope-layout'
var imagesLoaded = require('imagesloaded')

export default class extends ApplicationController {
  static classes = ["active"]
  static targets = [
    "filterDropdown",
    "stencil",
    "stencilColumn",
    "stencilPersonalization"
  ]
  static values = {
    visible: Boolean,
    maxStencils: Number,
    stencilIds: Array,
  }

  connect() {
    $(this.element).isotope({
      layoutMode: "masonry",
      itemSelector: "stencil"
    })

    $(this.filterDropdownTarget).on('change', function (event) {
      var $select = $(event.target)
      // get group key
      var filterGroup = $select.attr('value-group')
      // set filter for group
      filters[filterGroup] = event.target.value
      // combine filters
      var filterValue = filters
      // set filter for Isotope
      $grid.isotope({ filter: filterValue })
    })

    imagesLoaded(this.element).on('progress', function () {
      console.log('image loaded!')
      this.element.layout()
    })
  }

  disconnect() {
    this.element.isotope().destroy()
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
    this.stencilIdsValue = [0]
    this.notifySeatWizard()
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
