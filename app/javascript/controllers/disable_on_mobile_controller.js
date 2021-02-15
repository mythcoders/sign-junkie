import ApplicationController from "./application_controller"
import { isMobile } from "../helpers/platform_helpers"

export default class extends ApplicationController {
  connect() {
    this.element.disabled = isMobile
  }
}