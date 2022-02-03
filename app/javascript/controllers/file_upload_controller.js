import { Controller } from "@hotwired/stimulus"
import bsCustomFileInput from 'bs-custom-file-input'

export default class extends Controller {
  connect() {
    bsCustomFileInput.init()
  }
}