import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  disableOnSubmit(e) {
    e.target.disabled = true
    e.target.form.submit()
  }
}