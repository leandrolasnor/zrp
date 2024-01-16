import axios from 'axios'
import handle_errors from '../handle_errors'
import { toastr } from 'react-redux-toastr'

var _ = require('lodash')

export const historical_threats = pagination => {
  return dispatch => {
    axios.get('/v1/threats/historical', { params: {...pagination}}).then(resp =>{
      dispatch({ type: "HISTORICAL_THREATS_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
