export function get(name) {
  var cookies = document.cookie.split(";")
  for (var i = 0; i < cookies.length; i++) {
    var cookiePair = cookies[i].split("=")
    if (name == cookiePair[0].trim()) {
      return decodeURIComponent(cookiePair[1])
    }
  }
  return null
}

export function set(name, value, daysToLive = 365) {
  var cookie = name + "=" + encodeURIComponent(value) + "; path=/ "
  if (typeof daysToLive === "number") {
    cookie += "; max-age=" + (daysToLive * 24 * 60 * 60)
  }
  document.cookie = cookie
}