import axios from 'axios'
import handle_errors from '../handle_errors'
import { toastr } from 'react-redux-toastr'

const _ = require('lodash')

export const search = (query, pagination) => {
  return dispatch => {
    axios.get('/v1/heroes/search', { params: { ...pagination, query: query } }).then(resp => {
      dispatch({ type: "HEROES_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const create_hero = data => {
  return dispatch => {
    axios.post('/v1/heroes', data).then(resp => {
      dispatch({ type: 'HERO_CREATED', payload: resp.data })
      toastr.success('New Hero', _.get(resp, 'data.name', ''))
    }).catch(e => handle_errors(e))
  }
}

export const update_hero = data => {
  const { id } = data
  return dispatch => {
    axios.patch(`/v1/heroes/${id}`, data).then(resp => {
      dispatch({ type: 'HERO_UPDATED', payload: resp.data })
      toastr.success('Hero updated!', _.get(resp, 'data.name', ''))
    }).catch(e => handle_errors(e))
  }
}

export const get_ranks = () => {
  return dispatch => {
    axios.get('/v1/heroes/ranks').then(resp => {
      dispatch({ type: 'RANKS_FETCHED', payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
