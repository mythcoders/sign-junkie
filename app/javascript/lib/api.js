import { param } from "jquery"
import axios from "../helpers/axios_helpers"

const Api = {
  cartPath: '/cart',
  projectAddonsPath: '/projects/:projectId/addons',
  projectStencilsPath: '/projects/:projectId/stencils',
  sidebarPath: '/projects/:projectId/sidebar',
  workshopProjectsPath: '/workshops/:workshopId}/projects',

  projectAddons(projectId) {
    const url = Api.projectAddonsPath.replace(':projectId', encodeURIComponent(projectId))
    return axios.get(url)
  },

  projectStencils(projectId) {
    const url = Api.projectStencilsPath.replace(':projectId', encodeURIComponent(projectId))
    return axios.get(url)
  },

  sidebar(projectId, addonId, stencils) {
    const url = Api.sidebarPath.replace(':projectId', encodeURIComponent(projectId))
    return axios.post(url, {
      addon_id: addonId,
      stencils: stencils
    })
  },

  workshopProjects(workshopId, includeChildProjects = false) {
    const url = Api.workshopProjectsPath.replace(':workshopId', encodeURIComponent(workshopId))
    return axios.get(includeChildProjects ? `${url}?include_children=1` : url)
  },

  addToCart(params) {
    return axios.post(Api.cartPath, params)
  }
}

export default Api