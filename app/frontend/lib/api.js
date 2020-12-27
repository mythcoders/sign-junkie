import axios from "../helpers/axios_helpers"

const Api = {
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
      stencil_ids: stencils
    })
  },

  workshopProjects(workshopId, includeChildProjects = false) {
    const url = Api.workshopProjectsPath.replace(':workshopId', encodeURIComponent(workshopId))
    return axios.get(includeChildProjects ? `${url}?include_children=1` : url)
  }
}

export default Api