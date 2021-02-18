if (!window.__appClientLoaded) {
  window.__appClientLoaded = true

  require('@hotwired/turbo')
}

require("@rails/ujs").start()
// require("@rails/activestorage").start()
require("application")
