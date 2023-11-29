import { Configuration, PortalApi, SearchApi, VersionsApi, ProductsApi } from '@kong/sdk-portal-js'
import axios from 'axios'

export default class ApiService {
  constructor () {
    let baseURL = import.meta.env.DEV ? 'http://localhost:3036' : import.meta.env.VITE_PORTAL_API_URL;

    if (baseURL.endsWith('/')) {
      baseURL = baseURL.slice(0, -1)
    }

    this.baseURL = baseURL;

    this.client = axios.create({
      baseURL: this.baseURL,
      withCredentials: false,
      headers: {
        accept: 'application/json',
      }
    })

    const baseConfig = new Configuration({
      basePath: '',
      accessToken: 'bearerToken'
    })

    this.portalAPI = new PortalApi(baseConfig, this.baseURL, this.client);
    this.searchAPI = new SearchApi(baseConfig, this.baseURL, this.client);
    this.versionsAPI = new VersionsApi(baseConfig, this.baseURL, this.client);
    this.productsAPI = new ProductsApi(baseConfig, this.baseURL, this.client);
  }
}
