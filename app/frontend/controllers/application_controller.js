// application_controller.js
import { Controller } from "stimulus"

export default class extends Controller {
  sayHi() {
    console.log("Hello from the Application controller.")
  }
}