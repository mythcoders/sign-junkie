import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  static targets = [
    "body",
    "content",
    "stencilTemplate",
    "addonTemplate",
    "emptyTemplate",
    "header",
    "priceDisplay",
    "projectImage",
    "template",
  ]

  connect() {
    this.element[this.identifier] = this

    this.render()
  }

  render() {
    let seat = this.seat()

    if (seat.project.id !== undefined) {
      this.contentTarget.innerHTML = this.templateTarget.innerHTML

      this.headerTarget.innerHTML = seat.project.name
      this.projectImageTarget.src = seat.project.imageUrl

      var price = seat.project.price

      if (seat.addon.id !== undefined) {
        price += seat.addon.price
        // set the addon info
      }

      this.priceDisplayTarget.innerHTML = `$${price.toFixed(2)}`
    } else {
      this.contentTarget.innerHTML = this.emptyTemplateTarget.innerHTML
    }
  }

  // private

  seat() {
    return this.element['seat-wizard'].sidebarInformation
  }
}