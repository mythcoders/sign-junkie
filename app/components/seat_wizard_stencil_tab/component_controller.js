import ApplicationController from "../../javascript/controllers/application_controller"

export default class extends ApplicationController {
  static values = { visible: Boolean, maxStencils: Number, filters: String, stencils: Object }
  static targets = ["nextButton", "previousButton", "option", "column", "input", "personalization", "filter"]
  static classes = ["active", "disabled"]

  changeCategoryFilter(e) {
    this.filtersValue = e.currentTarget.value
    this.reset()
    this.columnTargets.forEach((e) => {
      if (this.filtersValue === '' || this.filtersValue === e.dataset.categoryId) {
        e.hidden = false
      } else {
        e.hidden = true
      }
    })
  }

  toggleStencil(e) {
    e.preventDefault()

    let newStencils = this.stencilsValue

    if (e.currentTarget.dataset.selected === 'true') {
      const { [e.currentTarget.dataset.id]: deletedKey, ...otherKeys } = newStencils
      newStencils = otherKeys
    } else {
      if (Object.keys(newStencils).length === this.maxStencilsValue) {
        if (this.maxStencilsValue === 1) {
          // in this scenario we want the selector to function as a toggle
          // and and we go ahead and 'unselect' the other stencil
          newStencils = {}
        } else {
          e.stopImmediatePropagation()
          alert("You've reached your limit on stencils. Please unselect an existing stencil before trying to select another one.")
          return
        }
      }

      newStencils[e.currentTarget.dataset.id] = e.currentTarget.dataset.allowPersonalization !== 'true' ? null : ''
    }

    this.stencilsValue = newStencils
    this.notifySeatWizard()
  }

  togglePlainOption(e) {
    this.visibleValue = e.currentTarget.checked
    this.stencilsValue = this.visibleValue ? { 0: '' } : {}
    this.filterTarget.hidden = this.visibleValue
    this.columnTargets.forEach((e) => { e.hidden = this.visibleValue })
  }

  updateStencilPersonalization(e) {
    ["|", "::"].forEach(c => {
      if (e.currentTarget.value.includes(c)) {
        e.currentTarget.value = e.currentTarget.value.replace(c, "")
        alert('invalid character')
      }
    })

    let newStencils = this.stencilsValue
    newStencils[e.currentTarget.dataset.id] = e.currentTarget.value
    this.stencilsValue = newStencils
  }

  get separatedInputValue() {
    let returnValue = ''
    for (const [key, value] of Object.entries(this.stencilsValue)) {
      // format: stencil_id|customization::
      returnValue += `${key}|${value}::`
    }
    return returnValue
  }

  // private

  stencilsValueChanged() {
    this.inputTarget.value = this.separatedInputValue
    if (Object.keys(this.stencilsValue).length === this.maxStencilsValue) {
      this.nextButtonTarget.classList.remove(this.disabledClass)
    }

    this.updateStencilTargets()
    this.updatePersonalizationTargets()
  }

  reset() {
    this.stencilsValue = {}
    this.notifySeatWizard()

    this.personalizationTargets.forEach((e) => { e.hidden = true })
    this.optionTargets.forEach((e) => {
      e.classList.remove(this.activeClass)
      e.dataset.selected = false
    })
  }

  notifySeatWizard() {
    document.dispatchEvent(new CustomEvent('SeatWizard:updateStencils', {
      detail: this.separatedInputValue
    }))
  }

  updateStencilTargets() {
    this.optionTargets.forEach((e) => {
      if (this.stencilsValue[e.dataset.id] !== undefined) {
        e.classList.add(this.activeClass)
        e.dataset.selected = 'true'
      } else {
        e.classList.remove(this.activeClass)
        e.dataset.selected = 'false'
      }
    })
  }

  updatePersonalizationTargets() {
    this.personalizationTargets.forEach((e) => {
      if (this.stencilsValue[e.dataset.id] !== undefined) {
        e.hidden = false
      } else {
        e.hidden = true
      }
    })
  }
}
