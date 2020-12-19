import ApplicationController from "../application_controller"

export default class extends ApplicationController {
  sayHi() {
    console.log("Hello from the AdminApplication controller.")
  }
}