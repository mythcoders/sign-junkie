import axios from './utils/axios_utils'

const Api = {
  adminWorkshopsPath: '/admin/workshops',
  cartPath: '/api/cart',
  workshopPath: '/workshops/:id',

  adminWorkshops() {
    return axios.get(Api.adminWorkshopsPath);
  },

  workshop(id) {
    const url = Api.workshopPath.replace(':id', encodeURIComponent(id))
    return axios.get(url);
  },

  addToCart(params) {
    return axios.post(Api.cartPath, params)
  }
};

export default Api;