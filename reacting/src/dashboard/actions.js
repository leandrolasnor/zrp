import axios from 'axios'
import handle_errors from '../handle_errors'

export const historical_threats = pagination => {
  return dispatch => {
    axios.get('/v1/threats/historical', { params: {...pagination}}).then(resp =>{
      dispatch({ type: "HISTORICAL_THREATS_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const get_metrics = () => {
  return dispatch => {
    let eventSource = new EventSource(`${process.env.REACT_APP_API_URL}/v1/metrics/dashboard`, {})
    eventSource.onmessage = (e) => dispatch(JSON.parse(e.data))
    eventSource.onerror = (e) => eventSource.close()
  }
}
