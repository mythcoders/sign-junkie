const { userAgent } = window.navigator

export const isIos = /iPhone|iPad/.test(userAgent)
export const isAndroid = /Android/.test(userAgent)
export const isMobile = isIos || isAndroid
export const isMac = /Mac/.test(userAgent)

export const isIosApp = /HEY iOS/.test(userAgent)
export const isAndroidApp = /Haystack Android/.test(userAgent)
export const isMobileApp = isIosApp || isAndroidApp
