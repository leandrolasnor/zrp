import { combineReducers } from 'redux'
import metrics from '../dashboard/reducer'
import {reducer as toastr} from 'react-redux-toastr'

const rootReducer = combineReducers({
  metrics,
  toastr
})

export default rootReducer
