import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  get classList() {
    return this.element.classList
  }

  dispatch(eventName, { target = this.element, detail = {}, bubbles = true, cancelable = true } = {}) {
    const type = `${this.identifier}:${eventName}`
    const event = new CustomEvent(type, { detail, bubbles, cancelable })
    target.dispatchEvent(event)
    return event
  }
}