import { combineReducers } from 'redux'
import auth from '../auth/reducer'
import {reducer as toastr} from 'react-redux-toastr'

const rootReducer = combineReducers({
  auth,
  toastr
})

export default rootReducer
