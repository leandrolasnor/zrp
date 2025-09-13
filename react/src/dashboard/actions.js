import axios from 'axios'
import handle_errors from '../handle_errors'

export const historical_threats = pagination => {
  return dispatch => {
    axios.get('/v1/threats/historical', { params: {...pagination}}).then(resp =>{
      dispatch({ type: "HISTORICAL_THREATS_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const set_insurgency = value => {
  return dispatch => {
    axios.post('/v1/threats/set_insurgency', { insurgency: value }).then(resp => {
      dispatch({ type: "SET_INSURGENCY", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
