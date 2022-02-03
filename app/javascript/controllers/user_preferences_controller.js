import { Controller } from "@hotwired/stimulus"
import { setCookie } from "../helpers/cookie_helpers"

export default class extends Controller {
  static targets = ["selectedAmount"]

  setTheme(event) {
    setCookie('sign_junkie_ui_theme', colorScheme)
  }

  saveUserPreferences() {
    toggleColorScheme(document.querySelector('[name="sign_junkie_ui_theme"]:checked').value)
    location.reload()
  }
}