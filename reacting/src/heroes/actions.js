import axios from 'axios'
import handle_errors from '../handle_errors'

export const search = (query, pagination) => {
  return dispatch => {
    axios.get('/v1/heroes/search', { params: { ...pagination, query: query } }).then(resp => {
      dispatch({ type: "HEROES_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const create_hero = data => {
  return dispatch => {
    axios.post('/v1/heroes', { params: { ...data } }).then(resp => {
      dispatch({type: 'HERO_CREATED', payload: resp.data})
    }).catch(e => handle_errors(e))
  }
}
