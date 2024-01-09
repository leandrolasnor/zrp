import { combineReducers } from 'redux'
import auth from '../auth/reducer'
import metrics from '../dashboard/reducer'
import {reducer as toastr} from 'react-redux-toastr'

const rootReducer = combineReducers({
  auth,
  metrics,
  toastr
})

export default rootReducer
