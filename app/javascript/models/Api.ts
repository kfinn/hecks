import Axios from 'axios';
import camelize from 'camelize';
import _ from 'lodash';
import snakeize from 'snakeize';

const Api = Axios.create()

Api.interceptors.request.use((config) => {
    const data = config.data
    if (data) {
        return { data: snakeize(data), ..._.omit(config, 'data') }
    }
    return config
})

Api.interceptors.response.use((response) => {
    const data = response.data
    if (data) {
        return { data : camelize(data), ..._.omit(response, 'data') }
    }
    return response
})

export default Api
