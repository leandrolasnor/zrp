import axios from 'axios'
import handle_errors from '../handle_errors'

export const list = pagination => {
  return dispatch => {
    axios.get('/v1/heroes/list', { params: { ...pagination } }).then(resp => {
      dispatch({ type: "HEROES_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
