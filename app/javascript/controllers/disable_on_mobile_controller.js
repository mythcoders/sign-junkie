import { Controller } from "@hotwired/stimulus"
import { isMobile } from "../helpers/platform_helpers"

export default class extends Controller {
  connect() {
    this.element.disabled = isMobile
  }
}