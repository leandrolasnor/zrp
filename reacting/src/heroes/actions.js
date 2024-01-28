import axios from 'axios'
import handle_errors from '../handle_errors'

export const search = (query, pagination) => {
  return dispatch => {
    axios.get('/v1/heroes/search', { params: { ...pagination, query: query } }).then(resp => {
      dispatch({ type: "HEROES_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
