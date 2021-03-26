import { Application } from "stimulus"

import MapController from "../maps/map_controller"

const application = Application.start()
application.register("map", MapController)
