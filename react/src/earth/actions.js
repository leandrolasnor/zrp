import axios from 'axios'
import handle_errors from '../handleErrors'

export const fetch_earth_threats = pagination => {
  return dispatch => {
    return axios.get('/v1/threats/historical', { params: { ...pagination } }).then(resp => {
      dispatch({ type: 'EARTH_THREATS_FETCHED', payload: resp.data })
      return resp.data
    }).catch(error => handle_errors(error))
  }
}

export const hover_threat = id => ({ type: 'EARTH_THREAT_HOVERED', payload: id })

export const select_threat = threat => ({ type: 'EARTH_THREAT_SELECTED', payload: threat })

export const close_threat = () => ({ type: 'EARTH_THREAT_CLOSED' })

export const rotate_earth = position => ({ type: 'EARTH_ROTATION_CHANGED', payload: position })
