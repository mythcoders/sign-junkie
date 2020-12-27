import ApplicationController from "./application_controller"
import cookie from "../helpers/cookie_helpers"

export default class extends ApplicationController {
  static targets = ["selectedAmount"]

  setTheme(event) {
    if (colorScheme == 'light') {
      document.cookie = 'apollo_ui_theme=light; path=/ '
    } else if (colorScheme == 'dark') {
      document.cookie = 'apollo_ui_theme=dark; path=/ '
    }
  }

  saveUserPreferences() {
    toggleColorScheme(document.querySelector('[name="apollo_ui_theme"]:checked').value)
    location.reload()
  }
}