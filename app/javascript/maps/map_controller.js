import ApplicationController from "../controllers/application_controller"
import mapboxgl from '!mapbox-gl'

export default class extends ApplicationController {
  static values = { accessToken: String, markerLabel: String, markerPosition: Array }

  connect() {
    mapboxgl.accessToken = this.accessTokenValue
    var map = new mapboxgl.Map({
      container: this.element.id,
      style: 'mapbox://styles/mapbox/satellite-v9',
      center: this.markerPositionValue,
      zoom: 17
    })
    new mapboxgl.Marker({ color: 'teal' }).setLngLat(this.markerPositionValue).addTo(map)
  }
}
