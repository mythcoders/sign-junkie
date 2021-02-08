import ApplicationController from "./application_controller"
import { isMobile } from "../helpers/platform_helpers"

export default class extends ApplicationController {
  initialize() {
    this.element.disabled = isMobile
  }
}