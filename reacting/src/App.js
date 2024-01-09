import { useSelector } from 'react-redux'
import {Container, Row} from 'react-bootstrap'
import NavBar from './navbar.js'
import Routes from './routes'
import { EventSourcePolyfill } from 'event-source-polyfill'
import axios from 'axios'
global.EventSource =  EventSourcePolyfill

const _ = require('lodash')

const App = () => {
  const { user } = useSelector(state => state.auth)
  axios.defaults.headers.common['Authorization'] = _.get(user, "authorization")

  return (
    <Container>
      <Row>
        <NavBar/>
      </Row>
      <Row>
        <Routes/>
      </Row>
    </Container>
  );
}

export default App
