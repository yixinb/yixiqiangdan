import axios from 'axios'

const api = axios.create({
  baseURL: '/api',
  timeout: 10000
})

api.interceptors.request.use(config => {
  const token = localStorage.getItem('admin_token')
  if (token) {
    config.headers.Authorization = `Bearer ${token}`
  }
  return config
})

export const adminApi = {
  login(username, password) {
    return api.post('/admin/login', { username, password })
  },
  generateCodes(count, durationDays) {
    return api.post('/admin/codes/generate', { count, durationDays })
  },
  listCodes() {
    return api.get('/admin/codes')
  },
  disableCode(code) {
    return api.post('/admin/codes/disable', { code })
  }
}

export default api
