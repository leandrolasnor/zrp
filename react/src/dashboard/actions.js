import axios from 'axios'
import handle_errors from '../handleErrors'
import ACTION_TYPES from './action_types'

let eventSource = null
let reconnectTimeout = null

const log = (...message) => {
  if (process.env.NODE_ENV === 'development') {
    console.log(...message)
  }
}

const widgets_url = () => `${process.env.REACT_APP_API_URL || ''}/v1/sse/widgets`

export const connect_widgets_stream = () => {
  return dispatch => {
    if (eventSource) eventSource.close()

    eventSource = new EventSource(widgets_url())

    ACTION_TYPES.forEach(eventType => {
      eventSource.addEventListener(eventType, event => {
        try {
          const payload = JSON.parse(event.data)
          dispatch({ type: eventType, payload })
        } catch (error) {
          console.error('SSE: Error parsing message', error)
        }
      })
    })

    eventSource.onopen = () => log('SSE: Connected')

    eventSource.onerror = error => {
      log('SSE: Disconnected', error)
      eventSource.close()
      if (reconnectTimeout) clearTimeout(reconnectTimeout)
      reconnectTimeout = setTimeout(() => {
        log('SSE: Attempting to reconnect...')
        dispatch(connect_widgets_stream())
      }, 5000)
    }
  }
}

export const disconnect_widgets_stream = () => {
  return () => {
    if (reconnectTimeout) {
      clearTimeout(reconnectTimeout)
      reconnectTimeout = null
    }
    if (eventSource) {
      eventSource.close()
      eventSource = null
    }
  }
}

export const historical_threats = pagination => {
  return dispatch => {
    return axios.get('/v1/threats/historical', { params: { ...pagination } }).then(resp => {
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
