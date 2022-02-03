# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "actiontext", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"

pin "@rails/actiontext", to: "https://ga.jspm.io/npm:@rails/actiontext@7.0.1/app/javascript/actiontext/index.js"
pin "@rails/activestorage", to: "https://ga.jspm.io/npm:@rails/activestorage@7.0.1/app/assets/javascripts/activestorage.esm.js"
pin "axios", to: "https://ga.jspm.io/npm:axios@0.21.4/index.js"
pin "#lib/adapters/http.js", to: "https://ga.jspm.io/npm:axios@0.21.4/lib/adapters/xhr.js"
pin "process", to: "https://ga.jspm.io/npm:@jspm/core@2.0.0-beta.14/nodelibs/browser/process-production.js"
pin "braintree-web-drop-in", to: "https://ga.jspm.io/npm:braintree-web-drop-in@1.32.1/dist/browser/dropin.js"
pin "mapbox-gl", to: "https://ga.jspm.io/npm:mapbox-gl@2.6.1/dist/mapbox-gl.js"
pin "jquery", to: "https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js"
pin "bs-custom-file-input", to: "https://ga.jspm.io/npm:bs-custom-file-input@1.3.4/dist/bs-custom-file-input.js"
pin "trix", to: "https://ga.jspm.io/npm:trix@1.3.1/dist/trix.js"
