import ApplicationController from "./application_controller"
import { setCookie } from "../helpers/cookie_helpers"

export default class extends ApplicationController {
  static targets = ["selectedAmount"]

  setTheme(event) {
    setCookie('apollo_ui_theme', colorScheme)
  }

  saveUserPreferences() {
    toggleColorScheme(document.querySelector('[name="apollo_ui_theme"]:checked').value)
    location.reload()
  }
}