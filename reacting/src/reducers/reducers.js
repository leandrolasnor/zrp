import { combineReducers } from 'redux'
import metrics from '../dashboard/reducer'
import heroes from '../heroes/reducer'
import {reducer as toastr} from 'react-redux-toastr'

const rootReducer = combineReducers({
  metrics,
  heroes,
  toastr
})

export default rootReducer
