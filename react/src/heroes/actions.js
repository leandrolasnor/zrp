import axios from 'axios'
import handle_errors from '../handleErrors'
import { toastr } from 'react-redux-toastr'

import qs from 'qs';
import _ from 'lodash'

export const search = (query, pagination, filter, sort) => {
  return dispatch => {
    dispatch({ type: 'HEROES_LOADING' })
    axios.get('/v1/heroes/search', {
      params: { ...pagination, filter: filter, query: query, sort: sort },
      paramsSerializer: params => qs.stringify(params, { arrayFormat: 'brackets' }),
    }).then(resp => {
      dispatch({ type: "HEROES_FETCHED", payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}

export const create_hero = data => {
  return dispatch => {
    return axios.post('/v1/heroes', data).then(resp => {
      dispatch({ type: 'HERO_CREATED', payload: resp.data })
      toastr.success('New Hero', _.get(resp, 'data.name', ''))
    }).catch(e => {
      handle_errors(e)
      throw e
    })
  }
}

export const update_hero = data => {
  const { id } = data
  return dispatch => {
    return axios.patch(`/v1/heroes/${id}`, data).then(resp => {
      dispatch({ type: 'HERO_UPDATED', payload: resp.data })
      toastr.success('Hero updated!', _.get(resp, 'data.name', ''))
    }).catch(e => {
      handle_errors(e)
      throw e
    })
  }
}

export const destroy_hero = data => {
  return dispatch => {
    axios.delete(`/v1/heroes/${data.id}`).then(resp => {
      dispatch({ type: 'HERO_DESTROYED', payload: resp.data })
      toastr.success('Hero destroyed!', _.get(resp, 'data.name', ''))
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

export const get_statuses = () => {
  return dispatch => {
    axios.get('/v1/heroes/statuses').then(resp => {
      dispatch({ type: 'STATUSES_FETCHED', payload: resp.data })
    }).catch(e => handle_errors(e))
  }
}
