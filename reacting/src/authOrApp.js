import { useEffect } from 'react'
import { useDispatch, useSelector } from 'react-redux'
import axios from 'axios'
import App from './App'
import Auth from './auth/auth';
import { validateToken } from './auth/actions'
import 'bootstrap/dist/css/bootstrap.min.css'
import 'react-redux-toastr/lib/css/react-redux-toastr.min.css'

const AuthOrApp = props => {
  const dispatch = useDispatch()
  const { validToken } = useSelector(state => state.auth)
  axios.defaults.baseURL = process.env.REACT_APP_API_URL
	axios.defaults.headers.common['Content-type'] = 'application/json';

  useEffect(() => {
    const local_storage = JSON.parse(localStorage.getItem(process.env.REACT_APP_APPLICATION_NAME)) || null
    if(local_storage && !validToken){
      dispatch(validateToken(local_storage));
    }
  },[dispatch, validToken])

  return(validToken ? <App/> : <Auth/>);
}

export default AuthOrApp
