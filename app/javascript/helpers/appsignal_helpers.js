import Appsignal from "@appsignal/javascript"

export default new Appsignal({
  key: document.querySelector("meta[name='sign-junkie-error-key']")?.content,
})
