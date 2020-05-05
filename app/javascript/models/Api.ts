import Axios from 'axios';
import camelize from 'camelize';
import $ from 'jquery';
import _ from 'lodash';
import snakeize from 'snakeize';

const Api = Axios.create({ baseURL: '/api/v1', responseType: 'json' })

const NON_MUTATIVE_METHODS = ['get', 'GET', 'head', 'HEAD', 'link', 'LINK', 'unlink', 'UNLINK']

Api.interceptors.request.use((config) => {
    if (_.includes(NON_MUTATIVE_METHODS, config.method)) {
        return config
    }
    const data = config.data || {}
    const authenticityToken = $('meta[name=csrf-token]').attr('content')
    const dataWithAuthToken = { authenticityToken, ...data }
    return { data: snakeize(dataWithAuthToken), ..._.omit(config, 'data') }
})

Api.interceptors.response.use((response) => {
    const data = response.data
    if (data) {
        return { data: camelize(data), ..._.omit(response, 'data') }
    }
    return response
})

export default Api
