import ApplicationController from "./application_controller"
import bsCustomFileInput from 'bs-custom-file-input'

export default class extends ApplicationController {
  connect() {
    bsCustomFileInput.init()
  }
}