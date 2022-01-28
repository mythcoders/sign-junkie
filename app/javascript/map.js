import { Application } from "@hotwired/stimulus"

import MapController from "./maps/map_controller"

window.Stimulus = Application.start()
Stimulus.register("map", MapController)
