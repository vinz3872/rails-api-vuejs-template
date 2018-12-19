import axios from 'axios'

const API_URL = 'http://localhost:3000'

const securedAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

const plainAxiosInstance = axios.create({
  baseURL: API_URL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

securedAxiosInstance.interceptors.request.use(config => {
  const method = config.method.toUpperCase()
  if (method !== 'OPTIONS' && method !== 'GET') {
    config.headers = {
      ...config.headers,
      // 'X-CSRF-TOKEN': localStorage.csrf
      'authorization': `Bearer ${window.sessionStorage.getItem('jwt')}`,
    }
  }
  return config
})

securedAxiosInstance.interceptors.response.use(null, error => {
  if (error.response && error.response.config && error.response.status === 401) {
    // In case 401 is caused by expired access cookie - we'll do refresh request
    return plainAxiosInstance.post('/refresh', {}, { headers: { 'authorization': `Bearer ${window.sessionStorage.getItem('jwt')}` } })
      .then(response => {
        const jwt = response.headers['authorization'].split('Bearer ')[1];
        window.sessionStorage.set('jwt', jwt);
        // sessionStorage.signedIn = true
        // And after successful refresh - repeat the original request
        let retryConfig = error.response.config;
        retryConfig.headers['authorization'] = `Bearer ${window.sessionStorage.getItem('jwt')}`;
        return plainAxiosInstance.request(retryConfig);
      }).catch(error => {
        window.sessionStorage.removeItem('jwt');
        // delete sessionStorage.signedIn
        // redirect to signin in case refresh request fails
        location.replace('/')
        return Promise.reject(error)
      })
  } else {
    return Promise.reject(error)
  }
})

export { securedAxiosInstance, plainAxiosInstance }