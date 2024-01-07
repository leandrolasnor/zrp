import axios from 'axios'
import handle_errors from '../handle_errors'
import { toastr } from 'react-redux-toastr'

var _ = require('lodash')

export const sign_in = values => {
  return dispatch => {
    axios.post('/auth/sign_in', values).then(resp => {
      dispatch({type: 'USER_FETCHED', payload: {data: resp.data.data, headers: resp.headers}})
    }).catch(e => {
      if(_.get(e, 'response.data', false)){
        if(_.get(e, 'response.data.errors', false)){
          toastr.error('Errors', JSON.stringify(e.response.data.errors.join(' ')).replace(/,|\d|:|[|]|'|{|}/g, ' '))
        }
      }else{
        handle_errors(e)
      }
    })
  }
}

export const sign_up = values => {
  return dispatch => {
    axios.post(`/auth`, values).then(resp => {
      dispatch({type: 'USER_FETCHED', payload: { data: resp.data.data, headers: resp.headers}})
    }).catch(e => {
      if(_.get(e, 'response.data', false)){
        if(_.get(e, 'response.data.errors.full_messages', false)){
          Object.entries(e.response.data.errors.full_messages).forEach(error => {
            toastr.error('', JSON.stringify(error[1]).replace(/,|\d|:|[|]|'|{|}/g, ' '))
          })
        }
      }else{
        handle_errors(e)
      }
    })
  }
}

export const logout = () => {
  return dispatch => {
    axios.delete(`/auth/sign_out`).then(resp => {
      if(resp.data.success){ dispatch({ type: 'LOGOUT' }) }
    }).catch(e => handle_errors(e))
  }
}

export const validateToken = data => {
  const config = {
    headers:{
      "uid": _.get(data,"uid"),
      "client":_.get(data,"client"),
      "access-token": _.get(data,"access-token"),
      'Authorization': _.get(data,"authorization")
    }
  }
  return dispatch => {
    axios.get('/auth/validate_token', config).then(resp => {
      dispatch({type: 'TOKEN_VALIDATED', payload: resp.data.success || false})
    }).catch(e => handle_errors(e))
  }
}
